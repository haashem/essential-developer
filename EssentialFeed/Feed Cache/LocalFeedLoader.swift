//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Hashem Aboonajmi on 8/3/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionErrro = error  {
                completion(cacheDeletionErrro)
            } else {
                self.cach(items, with: completion)
            }
        }
    }
    
    private func cach(_ items: [FeedItem], with completion: @escaping (Error?) -> Void) {
        store.insert(items, timestamp: currentDate(), insertionCompletion: { [weak self] error in
            guard let _ = self else { return }
            completion(error)
        })
    }
}
