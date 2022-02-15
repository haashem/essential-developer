//
//  FeedPresenterTests.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 13/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesntSendMessagesToView() {
        let (_, view) = makeSUT()
        _ = FeedPresenter(view: view)
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        return (sut, view)
    }
    
    private class ViewSpy {
        var messages = [Any]()
    }
}
