//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 16/05/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedValuesAndKeysExist(in: bundle, table)
    }
}
