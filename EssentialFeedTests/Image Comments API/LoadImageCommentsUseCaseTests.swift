//
//  LoadImageCommentsUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 27/03/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadImageCommentsUseCaseTests: XCTestCase {
    
    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        
        let (sut, client) = makeSUT()
       
        let samples = [199, 150, 300, 400, 500]
        
        samples.enumerated().forEach { (arg) in
            
            let (index, code) = arg
            expect(sut, toCompleteWithResult:
                failure(.invalidData), when: {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
        
    }
    
    func test_load_givenEmptyResponse_callsCompletionWithEmptyList() {
        let (sut, client) = makeSUT()
        
        let samples = [200, 210, 250, 280, 299]
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: .success([]), when: {
                let emptyListJSON = makeItemJSON([])
                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
            })
        }
    }
    
    func test_load_when2xxHTTPResponseWithInvalidData_deliversError() {
        let (sut, client) = makeSUT()
        let samples = [200, 210, 250, 280, 299]
       
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult:
                failure(.invalidData), when: {
                let invalidJSON = Data("invalid json".utf8)
                client.complete(withStatusCode: code, data: invalidJSON, at: index)
            })
        }
    }
    
    func test_load_deliversItemsOn2xxHTTPResponseWithValidJSONItems() {
        // given
        let (sut, client) = makeSUT()
        
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
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: .success([item1.model, item2.model]), when: {
                client.complete(withStatusCode: code, data: itemsJSON, at: index)
            })
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
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteImageCommentsLoader, toCompleteWithResult expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for load completion")
        sut.load { receivedResult in
            
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    private func makeSUT(url: URL = URL(string: "https://example.com")!) -> (RemoteImageCommentsLoader, HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
}

