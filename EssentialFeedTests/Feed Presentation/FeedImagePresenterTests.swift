//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 16/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {
        
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesntSendMessageToView() {
        let view = ViewSpy()
        _ = FeedImagePresenter(view: view)
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: Helper
    private class ViewSpy {
        var messages = [Any]()
    }
}
