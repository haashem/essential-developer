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
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionErrro = error  {
                completion(cacheDeletionErrro)
            } else {
                self.cach(feed, with: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, _):
                completion(.success(feed.toModels()))
            case .empty: completion(.success([]))
            }
        }
    }
    
    private func cach(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate(), insertionCompletion: { [weak self] error in
            guard let _ = self else { return }
            completion(error)
        })
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map{LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map{FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}
