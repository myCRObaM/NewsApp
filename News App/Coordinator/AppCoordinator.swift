//
//  AppCoordinator.swift
//  News App
//
//  Created by Matej Hetzel on 01/08/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    let tabBarController: TabBarController
    
    init (window: UIWindow){
        self.window = window
        tabBarController = TabBarController()
    }
    
    func start() {
        let myCoordinator = TabBarCoordinator(controller: tabBarController)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        myCoordinator.start()
    }
    
    
}
