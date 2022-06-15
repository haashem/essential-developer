//
//  FeedEndPointTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 15/06/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedEndPointTest: XCTestCase {
    
    func test_feed_endpointURL() {
        let baseUrl = URL(string: "https://base-url.com")!
        
        let received = FeedEndpoint.get.url(baseURL: baseUrl)
        let expected = URL(string: "https://base-url.com/v1/feed")
        
        XCTAssertEqual(received, expected)
    }
}
