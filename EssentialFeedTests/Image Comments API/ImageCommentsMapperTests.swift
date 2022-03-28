//
//  LoadImageCommentsUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 27/03/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        
        let samples = [199, 150, 300, 400, 500]
        let json = makeItemJSON([])
        try samples.forEach { code in
            try samples.forEach { code in
                XCTAssertThrowsError(try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code)))
            }
        }
    }
    
    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let samples = [200, 210, 250, 280, 299]
        let invalidJSON = Data("invalid json".utf8)
        
        try samples.forEach { code in
            XCTAssertThrowsError(try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code)))
        }
    }
    
    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyList() throws {
        let emptyListJSON = makeItemJSON([])
        let samples = [200, 210, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [])
        }
    }
    
    func test_map_deliversItemsOn2xxHTTPResponseWithValidJSONItems() throws {
        let item1 = makeItem(
                     id: UUID(),
                     message: "a message",
                     createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
                     username: "a username")

        let item2 = makeItem(
             id: UUID(),
             message: "another message",
             createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
             username: "another username")
        
        let itemsJSON = makeItemJSON([item1.json, item2.json])
        
        let samples = [200, 210, 250, 280, 299]
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(itemsJSON, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [item1.model, item2.model])
        }
    }
    
    // MARK: Helper
    
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
        
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        let json: [String: Any] = [
            "id": item.id.description,
            "message": item.message,
            "created_at": createdAt.iso8601String,
            "author": ["username": item.username]
            ]
        
        return (item, json)
    }
}

