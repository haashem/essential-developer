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


