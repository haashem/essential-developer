//
//  EssentialFeediOSTestsFile.swift
//  EssentialFeediOSTests
//
//  Created by Hashem Abounajmi on 18/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import XCTest

final class FeedViewController {
    
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helper
    
    class LoaderSpy {
        private(set) var loadCallCount = 0
    }
}
