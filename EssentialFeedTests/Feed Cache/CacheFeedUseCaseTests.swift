//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 8/2/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest

class LocalFeedLoader {
    
    init(store: FeedStore) {
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {

    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
