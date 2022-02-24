//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Hashem Abounajmi on 24/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import EssentialFeed

class StoreSpy: FeedImageDataStore {
   
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(_ data: Data, for: URL)
    }
    private(set) var receivedMessages = [Message]()
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    func insert(data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(data, for: url))
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
    }
}
