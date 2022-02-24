//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 23/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

final public class LocalFeedImageDataLoader {
    let store: FeedImageDataStore
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader {
    public typealias SaveResult = Result<Void, Swift.Error>
    
    public func save(data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data: data, for: url){ _ in}
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    
    public typealias LoadResult = FeedImageDataLoader.Result
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    final private class LoadImageDataTask: FeedImageDataLoaderTask {
        
        private(set) var completion: ((LoadResult) -> Void)?
        public init(_ completion: @escaping (LoadResult) -> Void) {
            self.completion = completion
        }
        
        public func complete(with result: LoadResult) {
            completion?(result)
        }
        
       public func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForURL: url){ [weak self] result in
            guard let _ = self else { return }
            task.complete(with:result
                        .mapError{ _ in LoadError.failed}
                        .flatMap{ data in
                            data.map{.success($0)} ?? .failure(LoadError.notFound)})
        }
        
        return task
    }
}
