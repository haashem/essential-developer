//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Hashem Abounajmi on 10/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

 final class FeedLocalizationTests: XCTestCase {

     func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
         let table = "Feed"
         let bundle = Bundle(for: FeedPresenter.self)
         assertLocalizedValuesAndKeysExist(in: bundle, table)
     }
 }
