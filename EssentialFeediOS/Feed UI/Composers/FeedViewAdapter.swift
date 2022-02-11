//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 11/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import UIKit
import EssentialFeed

final class FeedViewAdapter: FeedView {
    
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
             let view = FeedImageCellController(delegate: adapter)

             adapter.presenter = FeedImagePresenter(
                 view: WeakRefVirtualProxy(view),
                 imageTransformer: UIImage.init)

            return view
        }
    }
}

