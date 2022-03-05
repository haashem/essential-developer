//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Hashem Abounajmi on 05/03/2022.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderWithCacheDecorator: FeedImageDataLoader {
    
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { imageData in
                self?.cache.saveIgnoringResult(imageData, for: url)
                return imageData
            })
        }
    }
}

extension FeedImageDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url){ _ in }
    }
}
