//
//  LocalFeedImageDataLoader.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 22/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class LocalFeedImageDataLoaderTest: XCTestCase {
    
    func test_init_doesntMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let imageData = anyData()
        let url = anyURL()
        
        sut.save(data: imageData, for: url){ _ in }
        
        XCTAssertEqual(store.receivedMessages, [.insert(imageData, for: url)])
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    func test_loadImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWithResult: failed(), when: {
            store.complete(with: anyNSError())
        })
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWithResult: notFound(), when: {
            store.complete(with: .none)
        })
    }
    
    func test_loadImageDataFromURL_deliversStoredDataWhenFoundData() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        expect(sut, toCompleteWithResult: .success(foundData), when: {
            store.complete(with: foundData)
        })
    }
    
    func test_loadImageDataFromURL_doesntDeliverResultAfterCancelingTask() {
        let (sut, store) = makeSUT()
        
        var received = [FeedImageDataLoader.Result]()
        let task = sut.loadImageData(from: anyURL()){received.append($0)}
        task.cancel()
        
        let foundData = anyData()
        store.complete(with: foundData)
        store.complete(with: .none)
        store.complete(with: anyNSError())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
    }
    
    func test_loadImageDataFromURL_doesntDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = StoreSpy()
        var sut: LocalFeedImageDataLoader? = LocalFeedImageDataLoader(store: store)
        
        var received = [FeedImageDataLoader.Result]()
        _ = sut?.loadImageData(from: anyURL()){received.append($0)}
        sut = nil
        store.complete(with: anyData())
        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
    }
    
    private func failed() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.failed)
    }
    
    private func notFound() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.notFound)
    }

    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWithResult expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        _ = sut.loadImageData(from: anyURL(), completion: { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case (.failure(let receivedError as LocalFeedImageDataLoader.Error),
                  .failure(let expectedError as LocalFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
        })
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LocalFeedImageDataLoader, StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    // MARK: - Helper
    
    class StoreSpy: FeedImageDataStore {
       
        enum Message: Equatable {
            case retrieve(dataFor: URL)
            case insert(_ data: Data, for: URL)
        }
        private(set) var receivedMessages = [Message]()
        private var completions = [(FeedImageDataStore.Result) -> Void]()
        
        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receivedMessages.append(.retrieve(dataFor: url))
            completions.append(completion)
        }
        
        func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
            receivedMessages.append(.insert(data, for: url))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
        
        func complete(with data: Data?, at index: Int = 0) {
            completions[index](.success(data))
        }
    }
}
