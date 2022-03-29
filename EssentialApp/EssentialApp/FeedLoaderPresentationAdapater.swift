//
//  FeedLoaderPresentationAdapater.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 11/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class FeedLoaderPresentationAdapater: FeedViewControllerDelegate {
    private let feedLoader: () -> AnyPublisher<[FeedImage], Error>
    private var cancelable: Cancellable?
    var presenter: FeedPresenter?
    
    init(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        
        cancelable = feedLoader().sink(
        receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(let  error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }, receiveValue: { [weak self] feed in
            self?.presenter?.didFinishLoadingFeed(with: feed)
        })
    }
    
}
