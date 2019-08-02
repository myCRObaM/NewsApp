//
//  Coordinator.swift
//  News App
//
//  Created by Matej Hetzel on 01/08/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] {get set}
    //var presenter: UINavigationController {get set}
    func start()
}
extension Coordinator {
    func addCoordinator(coordinator: Coordinator){
        childCoordinators.append(coordinator)
    }

    func removeCoordinator(coordinator: Coordinator){
        childCoordinators = childCoordinators.filter { $0 !== coordinator}
    }
}
