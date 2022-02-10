//
//  FeedViewControllerTest+Localizations.swift
//  EssentialFeediOSTests
//
//  Created by Hashem Abounajmi on 10/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if (value == key) {
            XCTFail("Missing localized string for key:  \(key)")
        }
        return value
    }
}
