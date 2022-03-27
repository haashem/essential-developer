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
    func test_init_doesntRequestURL() {
        let client = HTTPClientSpy()
        _ = makeSUT()
        
        XCTAssertTrue(client.messages.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{_ in }
        sut.load{_ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let givenError = NSError(domain: "test", code: 0, userInfo: nil)
        
        expect(sut, toCompleteWithResult:
            failure(.connectivity), when: {
            client.complete(with: givenError)
        })
    }
    
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
        
        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://example.com")!)
        
        
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://example.com")!)
        
        let itemsJSON = makeItemJSON([item1.json, item2.json])
        
        let samples = [200, 210, 250, 280, 299]
        samples.enumerated().forEach { (index, code) in
            expect(sut, toCompleteWithResult: .success([item1.model, item2.model]), when: {
                client.complete(withStatusCode: code, data: itemsJSON, at: index)
            })
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTinstanceHasBeenDeallocated() {
        let url = URL(string: "http://example.com")!
        let client = HTTPClientSpy()
        var sut: RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)
        
        // when
        var capturedResults = [RemoteImageCommentsLoader.Result]()
        
        sut?.load {
            capturedResults.append($0)
        }
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
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

