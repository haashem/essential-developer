//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 3/12/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    
    let client: HTTPClient
    let url: URL
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_init_doesntRequestURL() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://example.com")!
        _ = RemoteFeedLoader(url: url, client: HTTPClientSpy())
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://example.com")!
        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
}
