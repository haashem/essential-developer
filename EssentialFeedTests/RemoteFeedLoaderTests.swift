//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 3/12/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest
@testable import EssentialFeed


class RemoteFeedLoaderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
        
        expect(sut, toCompleteWithResult: RemoteFeedLoader.Result.failure(.connectivity), when: {
            client.complete(with: givenError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        
        let (sut, client) = makeSUT()
       
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { (arg) in
            
            let (index, code) = arg
            expect(sut, toCompleteWithResult: RemoteFeedLoader.Result.failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
        
    }
    
    func test_load_givenEmptyResponse_callsCompletionWithEmptyList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJSON = Data("{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_when200HTTPResponseWithInvalidData_deliversError() {
        
        // given
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: RemoteFeedLoader.Result.failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_whenValidJSONdata_callCompletionWithFeedItems() {
        // given
        let (sut, client) = makeSUT()
        
        let item1 = FeedItem(id: UUID(), description: nil, location: nil, imageURL: URL(string: "http://example.com")!)
        let item1JSON = [
            "id": item1.id.description,
            "imageURL": item1.imageURL.absoluteString
        ]
        
        let item2 = FeedItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://example.com")!)
        
        let item2JSON = [
            "id": item2.id.description,
            "location": item2.location,
            "description": item2.description,
            "imageURL": item2.imageURL.absoluteString
        ]
        
        let itemsJSON = ["items": [item1JSON, item2JSON]]
        
        expect(sut, toCompleteWithResult: .success([item1, item2]), when: {
            client.complete(withStatusCode: 200, data: try! JSONSerialization.data(withJSONObject: itemsJSON))
        })
        
    }
    // MARK: Helper
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithResult result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut.load {
            capturedResults.append($0)
        }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeSUT(url: URL = URL(string: "https://example.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
