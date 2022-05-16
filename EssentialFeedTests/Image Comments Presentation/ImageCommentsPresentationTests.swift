//
//  ImageCommentsPresentationTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 16/05/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsPresentationTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
    // MARK: Helper
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if (value == key) {
            XCTFail("Missing localized string for key:  \(key)")
        }
        return value
    }
}
