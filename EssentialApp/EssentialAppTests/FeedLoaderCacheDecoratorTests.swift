//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Hashem Abounajmi on 02/03/2022.
//

import XCTest
import EssentialFeed

protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}

final class FeedLoaderCacheDecorator: FeedLoader {
    
    let decoratee: FeedLoader
    let cache: FeedCache
    
    init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load() { [weak self] result in
            self?.cache.save((try? result.get()) ?? []){ _ in }
            completion(result)
        }
    }
}

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
    
    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed))
        expect(sut, toCompleteWith: .success(feed))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_load_cachesFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let cacheSpy = CacheSpy()
        let sut = makeSUT(loaderResult: .success(feed), cache: cacheSpy)
        sut.load(){ _ in }
        
        XCTAssertEqual(cacheSpy.messages, [.save(feed)])
    }
    
    // MARK: Helper
    
    private func makeSUT(loaderResult: FeedLoader.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> FeedLoaderCacheDecorator {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private class CacheSpy: FeedCache {
        var messages = [Message]()
        
        enum Message: Equatable {
            case save([FeedImage])
        }
        
        func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(feed))
            completion(.success(()))
        }
    }
}
