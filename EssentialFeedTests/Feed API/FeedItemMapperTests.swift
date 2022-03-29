//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 3/12/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedItemMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        let json = makeItemJSON([])
        
        try samples.forEach { code in
            XCTAssertThrowsError(try FeedItemMapper.map(json, from: HTTPURLResponse(statusCode: code)))
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(try FeedItemMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200)))
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithJSONEmptyList() throws {
        let emptyListJSON = makeItemJSON([])
        
        let result = try FeedItemMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, [])
    }
    
    func test_load_whenValidJSONdata_callCompletionWithFeedItems() throws {

        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://example.com")!)
        
        
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://example.com")!)
        
        let itemsJSON = makeItemJSON([item1.json, item2.json])
        
        let result = try FeedItemMapper.map(itemsJSON, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: Helper
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)
        let json = [
            "id": item.id.description,
            "location": item.location,
            "description": item.description,
            "image": item.url.absoluteString
            ].compactMapValues{$0}
        
        return (item, json)
    }
}
