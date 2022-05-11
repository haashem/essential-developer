//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 15/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public final class FeedPresenter {
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        return FeedViewModel(feed: feed)
    }
}
