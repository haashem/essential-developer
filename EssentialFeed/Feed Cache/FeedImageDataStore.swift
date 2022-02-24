//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 23/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
