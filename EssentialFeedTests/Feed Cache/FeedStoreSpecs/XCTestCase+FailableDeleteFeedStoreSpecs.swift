//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 8/12/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

extension FailableDeleteFeedstoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
         let deletionError = deleteCache(from: sut)

          XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
     }

      func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
         deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.none), file: file, line: line)
     }
}
