//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 26/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit
import EssentialFeed

final public class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = { [weak feedController] feed in
            feedController?.tableModel = feed.map { model in FeedImageCellController(model: model, imageLoader: imageLoader)}
        }
        return feedController
    }
}
