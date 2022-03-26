//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 26/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final public class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: FeedImageDataLoader) -> FeedViewController {
        
        let presentationAdapater = FeedLoaderPresentationAdapater(feedLoader: {
            feedLoader().dispatchToMainQueue()
        })
        
        let feedController = makeFeedViewController(delegate: presentationAdapater, title: FeedPresenter.title)
        presentationAdapater.presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedController, imageLoader: MainQueueDispatchDecorater(decoratee: imageLoader)), loadingView: WeakRefVirtualProxy(feedController), errorView: WeakRefVirtualProxy(feedController))
        
        return feedController
    }
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storybaord = UIStoryboard(name: "Feed", bundle: bundle.self)
        let feedController = storybaord.instantiateInitialViewController() as! FeedViewController
        feedController.title = FeedPresenter.title
        feedController.delegate = delegate
        return feedController;
    }
}
