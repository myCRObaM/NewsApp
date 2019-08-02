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
    var parent: TabBarController
    var changeFavoriteStateDelegate: FavoriteDelegate?
    
    init (parent: TabBarController, root: TabBarCoordinator){
        self.parent = parent
        let favoriteNewsTableViewController = FavoriteNewsViewController()
        favoriteNewsTableViewController.changeFavoriteStateDelegate = root
        root.favoriteNewsViewController = favoriteNewsTableViewController
    }
    
    func start() {
    }
    
    
}

