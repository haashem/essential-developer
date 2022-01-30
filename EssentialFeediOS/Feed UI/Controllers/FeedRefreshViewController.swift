//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 25/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()
    
    private var feedPresenter: FeedPresenter
    
    init(presenter: FeedPresenter) {
        self.feedPresenter = presenter
    }
    
    func display(isLoading: Bool) {
        if isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    @objc func refresh() {
        feedPresenter.loadFeed()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
}
