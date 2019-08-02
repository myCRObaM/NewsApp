//
//  FavoriteNewsTableCoordinator.swift
//  News App
//
//  Created by Matej Hetzel on 01/08/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class FavoriteNewsTableCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var parent: UINavigationController
    var changeFavoriteStateDelegate: FavoriteDelegate?
    
    init (navController: UINavigationController, root: TabBarCoordinator){
        self.parent = navController
        let favoriteNewsTableViewController = FavoriteNewsViewController()
        favoriteNewsTableViewController.changeFavoriteStateDelegate = root
        favoriteNewsTableViewController.selectedDetailsDelegate = self
        root.favoriteNewsViewController = favoriteNewsTableViewController
    }
    
    func start() {
    }
}
extension FavoriteNewsTableCoordinator: DetailsNavigationDelegate, ChildHasFinishedDelegate, WorkIsDoneDelegate{
    
    func openDetailsView(news: Article) {
        let details = DetailsViewCoordinator(navController: parent, news: news, root: self)
        self.addCoordinator(coordinator: details)
        details.childFinishedDelegate = self
        self.addCoordinator(coordinator: details)
        details.start()
    }
    func childIsDone(coordinator: Coordinator) {
        self.removeCoordinator(coordinator: coordinator)
        print(coordinator)
    }
    
    func done(cooridinator: Coordinator) {
        childCoordinators.removeAll()
        childIsDone(coordinator: cooridinator)
    }
}


