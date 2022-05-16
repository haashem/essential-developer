//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 16/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedImagePresenterTests: XCTestCase {
    
    
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
    
}
