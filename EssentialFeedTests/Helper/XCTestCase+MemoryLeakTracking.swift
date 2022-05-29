//
//  XCTestCase+TrackMemoryLeak.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 7/16/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: #filePath, line: #line)
        }
    }
}
