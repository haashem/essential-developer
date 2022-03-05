//
//  FeedImageLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Hashem Abounajmi on 28/02/2022.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageLoaderWithFallbackCompositeTests: XCTestCase, FeedImageDataLoaderTestCase {
    
    func test_init_doesNotLoadImageData() {
        
        let (_, primaryLoader, fallbackLoader) = makeSUT()

        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
       
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    func test_loadImageData_loadsFromFallbackOnPrimaryFailure() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
       
        _ = sut.loadImageData(from: url) { _ in }
        primaryLoader.complete(with: anyNSError())
        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertEqual(fallbackLoader.loadedURLs, [url], "Expected to load URL from fallback loader")
    }
    
    func test_cancelLoadImageData_cancelsPrimaryLoaderTask() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
       
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(primaryLoader.cancelledURLs, [url], "Expected to cancel URL loading from primary loader")
        XCTAssertTrue(fallbackLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs in the fallback loader")
    }
    
    func test_cancelLoadImageData_cancelsFallbackLoaderTaskAfterPrimaryLoaderFailure() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
       
        let task = sut.loadImageData(from: url) { _ in }
        primaryLoader.complete(with: anyNSError())
        task.cancel()
        
        XCTAssertTrue(primaryLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs in  primary loader")
        XCTAssertEqual(fallbackLoader.cancelledURLs, [url], "Expected to cancel URL loading in the fallback loader")
    }
    
    func test_loadImageData_deliversImageDataOnPrimaryLoaderSuccess() {
        
        let primaryImageData = anyData()
        let (sut, primaryLoader, _) = makeSUT()
        
        expect(sut, toCompleteWith: .success(primaryImageData)) {
            primaryLoader.complete(with: primaryImageData)
        }
    }
    
    func test_loadImageData_deliversFallbackDataOnFallbackLoaderSuccess() {
        
        let fallbackImageData = anyData()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        expect(sut, toCompleteWith: .success(fallbackImageData)) {
            primaryLoader.complete(with: anyNSError())
            fallbackLoader.complete(with: fallbackImageData)
        }
    }
    
    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackFailure() {
   
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError())) {
            primaryLoader.complete(with: anyNSError())
            fallbackLoader.complete(with: anyNSError())
        }
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoader, primary: FeedImageDataLoaderSpy, fallback: FeedImageDataLoaderSpy) {
        let primaryLoader = FeedImageDataLoaderSpy()
        let fallbackLoader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, primaryLoader, fallbackLoader)
    }
}
