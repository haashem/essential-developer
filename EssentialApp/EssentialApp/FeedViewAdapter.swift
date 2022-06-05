//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 11/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private let selection: (FeedImage) -> Void
    
    init(
        controller: ListViewController,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: Paginated<FeedImage>) {
        controller?.display(viewModel.items.map { model in
            
            let adapter = LoadResourcePresentationAdapater<Data, WeakRefVirtualProxy<FeedImageCellController>>(loader: { [imageLoader] in
                imageLoader(model.url)
            })
            
            let view = FeedImageCellController(
                viewModel:
                    FeedImagePresenter.map(model),
                delegate: adapter, selection: { [selection] in
                    selection(model)
                })

            adapter.presenter = LoadResourcePresenter(resourceView: WeakRefVirtualProxy(view), loadingView: WeakRefVirtualProxy(view), errorView: WeakRefVirtualProxy(view), mapper: { data in
                guard let image = UIImage(data: data) else {
                    throw InvalidImageData()
                }
                return image
            })

            return CellController(id: model, view)
        })
    }
}

private struct InvalidImageData: Error {}
