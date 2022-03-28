//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 3/12/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed


class LoadFromRemoteUseCaseTests: XCTestCase {

    func test_load_deliversErrorOnNon200HTTPResponse() {
        
        let (sut, client) = makeSUT()
       
        let samples = [199, 201, 300, 400, 500]
        
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
        
        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJSON = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_when200HTTPResponseWithInvalidData_deliversError() {
        
        // given
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult:
            failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_whenValidJSONdata_callCompletionWithFeedItems() {
        // given
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://example.com")!)
        
        
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://example.com")!)
        
        let itemsJSON = makeItemJSON([item1.json, item2.json])
        
        expect(sut, toCompleteWithResult: .success([item1.model, item2.model]), when: {
            client.complete(withStatusCode: 200, data: itemsJSON)
        })
        
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
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithResult expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for load completion")
        sut.load { receivedResult in
            
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    private func makeSUT(url: URL = URL(string: "https://example.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
}
