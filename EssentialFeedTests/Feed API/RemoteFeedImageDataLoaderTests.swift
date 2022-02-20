//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 20/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed


class RemoteFeedImageDataLoader {
    init(client: Any) {
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
 
    func test_init_doesntPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy {
        var requestedURLs = [URL]()
    }
}

