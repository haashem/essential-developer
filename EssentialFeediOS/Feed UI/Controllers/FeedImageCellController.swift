//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 25/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

protocol FeedImageCellControllerDelegate {
     func didRequestImage()
     func didCancelImageRequest()
 }

final class FeedImageCellController: FeedImageView {
    
    
    private var delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.feedImageView.setImageAnimated(viewModel.image)
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
        cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell?.onRetry = delegate.didRequestImage
    }
    
    func preload() {
        delegate.didRequestImage()
    }

    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
