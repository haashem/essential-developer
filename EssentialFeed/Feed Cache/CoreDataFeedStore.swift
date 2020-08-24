//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Hashem Aboonajmi on 8/24/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {
    public init() {}

    public func retrieve(completion: @escaping RetrievalCompletion) {
      completion(.empty)
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, insertionCompletion   completion: @escaping InsertionCompletion) {

    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {

    }

}

