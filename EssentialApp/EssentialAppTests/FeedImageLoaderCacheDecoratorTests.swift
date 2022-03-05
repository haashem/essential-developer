//
//  FeedImageLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Hashem Abounajmi on 05/03/2022.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithCacheDecorator: FeedImageDataLoader {
    
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { imageData in
                self?.cache.save(imageData, for: url){ _ in }
                return imageData
            })
        }
    }
}

class FeedImageLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
  
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()
        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
    }
    
    func test_loadImageData_loadsFromLoader() {
        let (sut, loader) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
    }
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        let (sut, loader) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(loader.cancelledURLs, [url], "Expected to cancel URL loading from loader")
    }
    
    func test_loadImageData_deliversImageDataOnSuccess() {
        
        let imageData = anyData()
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .success(imageData), when: {
            loader.complete(with: imageData)
        })
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            loader.complete(with: anyNSError())
        })
    }
    
    func test_loadImageData_cachesImageDataOnLoaderSuccess() {
        let imageData = anyData()
        let loader = FeedImageDataLoaderSpy()
        let cacheSpy = CacheSpy()
        let sut = FeedImageDataLoaderWithCacheDecorator(decoratee: loader, cache: cacheSpy)
        
        _ = sut.loadImageData(from: anyURL()){ result in }
        loader.complete(with: imageData)
        
        XCTAssertEqual(cacheSpy.messages, [.save(imageData)], "Expected to cache loaded image data on success")
    }
    
    func test_loadImageData_doesntCacheImageDataOnLoaderFailure() {

        let loader = FeedImageDataLoaderSpy()
        let cacheSpy = CacheSpy()
        let sut = FeedImageDataLoaderWithCacheDecorator(decoratee: loader, cache: cacheSpy)
        
        _ = sut.loadImageData(from: anyURL()){ result in }
        loader.complete(with: anyNSError())
        
        XCTAssertEqual(cacheSpy.messages, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (FeedImageDataLoader, FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let cacheSpy = CacheSpy()
        let sut = FeedImageDataLoaderWithCacheDecorator(decoratee: loader, cache: cacheSpy)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class CacheSpy: FeedImageDataCache {
        
        var messages = [Message]()
        
        enum Message: Equatable {
            case save(Data)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data))
        }
    }
}
