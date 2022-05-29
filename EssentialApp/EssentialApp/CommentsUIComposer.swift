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
    
    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>) -> ListViewController {
        
        let presentationAdapater = LoadResourcePresentationAdapater<[ImageComment], CommentsViewAdapter>(loader: {
            commentsLoader().dispatchToMainQueue()
        })
        
        let commentsController = makeCommentsViewController(title: ImageCommentsPresenter.title)
        commentsController.onRefresh = presentationAdapater.loadResource
        
        presentationAdapater.presenter = LoadResourcePresenter(resourceView: CommentsViewAdapter(controller: commentsController), loadingView: WeakRefVirtualProxy(commentsController), errorView: WeakRefVirtualProxy(commentsController), mapper: { ImageCommentsPresenter.map(comments: $0) })
        
        return commentsController
    }
    
    private static func makeCommentsViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storybaord = UIStoryboard(name: "ImageComments", bundle: bundle.self)
        let controller = storybaord.instantiateInitialViewController() as! ListViewController
        controller.title = title
        return controller;
    }
}

final class CommentsViewAdapter: ResourceView {
    
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}

final class DataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
