//
//  NewsTableViewCoordinator.swift
//  News App
//
//  Created by Matej Hetzel on 01/08/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class NewsTableViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var parent: TabBarController
    var changeFavoriteStateDelegate: FavoriteDelegate?
    
    init (parent: TabBarController, root: TabBarCoordinator){
        self.parent = parent
        let NTVC = NewsTableViewController()
        NTVC.changeFavoriteStateDelegate = root
        root.allNewsViewController = NTVC
    }
    
    
    func start() {
    }
}


