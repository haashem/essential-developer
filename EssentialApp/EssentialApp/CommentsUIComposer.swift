//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Hashem Abounajmi on 28/05/2022.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

final public class CommentsUIComposer {
    
    private init() {}
    
    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) -> ListViewController {
        
        let presentationAdapater = LoadResourcePresentationAdapater<[FeedImage], FeedViewAdapter>(loader: {
            commentsLoader().dispatchToMainQueue()
        })
        
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapater.loadResource
        
        presentationAdapater.presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedController, imageLoader: { _ in Empty<Data, Error>().eraseToAnyPublisher() }), loadingView: WeakRefVirtualProxy(feedController), errorView: WeakRefVirtualProxy(feedController), mapper: FeedPresenter.map)
        
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
