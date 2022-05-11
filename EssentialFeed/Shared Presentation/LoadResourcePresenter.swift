//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 11/05/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation


public protocol ResourceView {
    func display(_ viewModel: String)
}

public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    private let resourceView: ResourceView
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let mapper: Mapper
    
    public init(resourceView: ResourceView,
                loadingView: FeedLoadingView,
                errorView: FeedErrorView,
                mapper: @escaping Mapper
    ) {
        self.resourceView = resourceView
        self.errorView = errorView
        self.loadingView = loadingView
        self.mapper = mapper
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
             tableName: "Feed",
             bundle: Bundle(for: FeedPresenter.self),
             comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(message: feedLoadError))
    }
}
