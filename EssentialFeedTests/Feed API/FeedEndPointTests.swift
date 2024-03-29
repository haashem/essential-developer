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
        let baseUrl = URL(string: "http://base-url.com")!
        
        let received = FeedEndpoint.get().url(baseURL: baseUrl)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query, "limit=10", "query")
    }
    
    func test_feed_endpointURLAfterGivenImage() {
        let image = uniqueImage()
        let baseUrl = URL(string: "http://base-url.com")!
        
        let received = FeedEndpoint.get(after: image).url(baseURL: baseUrl)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query?.contains("limit=10"), true, "limit query param")
        XCTAssertEqual(received.query?.contains("after_id=\(image.id)"), true, "after_id query param")
    }
}
