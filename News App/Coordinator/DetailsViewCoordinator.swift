//
//  DetailsViewCoordinator.swift
//  News App
//
//  Created by Matej Hetzel on 01/08/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    var loadedNews: Article
    var model: ViewNewsModelView
    var changeFavoriteStateDelegate: FavoriteDelegate?
    var detailsViewController: ViewNewsController
    
    init(presenter: UINavigationController, loadedNews: Article, model: ViewNewsModelView) {
        self.presenter = presenter
        self.loadedNews = loadedNews
        self.model = model
       // changeFavoriteStateDelegate = delegate
         let details = ViewNewsController(news: loadedNews, model: model)
        self.detailsViewController = details
    }
    
    func start() {
        detailsViewController.buttonIsPressedDelegate = self
        presenter.pushViewController(detailsViewController, animated: true)
    }
}

