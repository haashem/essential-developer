//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 8/4/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionsCompletions = [DeletionCompletion]()
    private var insertionsCompletions = [InsertionCompletion]()
    private var retreivalCompletions = [RetrievalCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionsCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionsCompletions[index](error)
    }
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionsCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
         deletionsCompletions[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, insertionCompletion: @escaping InsertionCompletion) {
        insertionsCompletions.append(insertionCompletion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
         insertionsCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retreivalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retreivalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retreivalCompletions[index](.empty)
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retreivalCompletions[index](.found(feed: feed, timestamp: timestamp))
    }
}
