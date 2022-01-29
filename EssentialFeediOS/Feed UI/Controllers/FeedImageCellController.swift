//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 25/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

final class FeedImageCellController {
    
    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        viewModel.loadImageData()
        return cell
    }
    
    private var viewModel: FeedImageViewModel
    
    init(viewModel: FeedImageViewModel) {
        self.viewModel = viewModel
    }
    
    private func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }
        
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }

         viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
             cell?.feedImageRetryButton.isHidden = !shouldRetry
         }
        return cell
    }
    
    func preload() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }
}
