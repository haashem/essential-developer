//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 8/6/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation


func anyNSError() -> NSError {
    return NSError(domain:"any error", code: 0, userInfo: nil)
}

func anyURL() ->URL {
    return URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}


extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

func makeItemJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
}
