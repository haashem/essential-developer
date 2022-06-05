//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 26/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

final public class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
        imageLoader:  @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) -> ListViewController {
        
        let presentationAdapater = LoadResourcePresentationAdapater<Paginated<FeedImage>, FeedViewAdapter>(
            loader: {
                feedLoader().dispatchToMainQueue()
            }
        )
        
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapater.loadResource
        
        presentationAdapater.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { imageLoader($0).dispatchToMainQueue() },
                selection: selection),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: { $0 })
        
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storybaord = UIStoryboard(name: "Feed", bundle: bundle.self)
        let feedController = storybaord.instantiateInitialViewController() as! ListViewController
        feedController.title = FeedPresenter.title
        return feedController;
    }
}
