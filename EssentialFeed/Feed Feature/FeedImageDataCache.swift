//
//  FeedImageCache.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 05/03/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Swift.Error>
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
