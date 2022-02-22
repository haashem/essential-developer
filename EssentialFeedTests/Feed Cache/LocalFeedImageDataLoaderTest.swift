//
//  LocalFeedImageDataLoader.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 22/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest

protocol FeedImageDataStore {
    func retrieve(dataForURL url: URL)
}

final class LocalFeedImageDataLoader {
    let store: FeedImageDataStore
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL) {
        store.retrieve(dataForURL: url)
    }
}

class LocalFeedImageDataLoaderTest: XCTestCase {
    
    func test_init_doesntMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        sut.loadImageData(from: url)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
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
        }
        private(set) var receivedMessages = [Message]()
        
        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }
}
