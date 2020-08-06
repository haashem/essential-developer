//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Hashem Aboonajmi on 8/6/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueImage(), uniqueImage()]
    let localItems = items.map{ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    
    return (items, localItems)
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
