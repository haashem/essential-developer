//
//  XCTestCase+FeedLoader.swift
//  EssentialAppTests
//
//  Created by Hashem Abounajmi on 02/03/2022.
//

import Foundation
import XCTest
import EssentialFeed

extension XCTestCase {
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file:  StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed)
            case (.failure, .failure):
                break
                
            default:
                XCTFail("expected \(expectedResult) load feed result, got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}
