//
//  FeedViewControllerTest+Localizations.swift
//  EssentialFeediOSTests
//
//  Created by Hashem Abounajmi on 10/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadError: String {
        return LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        return FeedPresenter.title
    }
    
}
