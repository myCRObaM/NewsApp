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
    weak var parentCoordinator: TabBarCoordinator?
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    var singleNews: Article
    weak var childFinishedDelegate: WorkIsDoneDelegate?
    let model = ViewNewsModelView()
    
    init (navController: UINavigationController, news: Article, root: ChildHasFinishedDelegate){
        self.navController = navController
        singleNews = news
    }
    
    
    func start() {
        let ViewController = ViewNewsController(news: singleNews, model: model)
        ViewController.workIsDelegate = childFinishedDelegate
        ViewController.coordinator = self
        navController.pushViewController(ViewController, animated: true)
    }
    
}

