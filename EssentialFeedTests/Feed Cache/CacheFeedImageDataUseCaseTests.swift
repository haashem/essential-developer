//
//  CacheFeedImageDataUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 24/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class CacheFeedImageDataUseCaseTests: XCTestCase {
    
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
    
    // MARK: - Helpers
        
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
