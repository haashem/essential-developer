//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 30/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    
    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?
    
    func didStartLoading() {
        feedLoadingView?.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView?.display(FeedViewModel(feed: feed))
        feedLoadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        feedLoadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
}
