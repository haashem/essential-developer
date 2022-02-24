//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 23/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

final public class LocalFeedImageDataLoader: FeedImageDataLoader {
    
    final private class Task: FeedImageDataLoaderTask {
        
        private(set) var completion: ((FeedImageDataLoader.Result) -> Void)?
        public init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        public func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
       public func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }

    let store: FeedImageDataStore
    public init(store: FeedImageDataStore) {
        self.store = store
    }
    
    public typealias SaveResult = Result<Void, Swift.Error>
    
    public func save(data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data: data, for: url){ _ in}
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        
        let task = Task(completion)
        store.retrieve(dataForURL: url){ [weak self] result in
            guard let _ = self else { return }
            task.complete(with:result
                        .mapError{ _ in Error.failed}
                        .flatMap{ data in data.map{.success($0)} ?? .failure(Error.notFound)})
        }
        
        return task
    }
}
