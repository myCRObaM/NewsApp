//
//  DetailsFlowDelegate.swift
//  News App
//
//  Created by Matej Hetzel on 02/08/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit

protocol ChildHasFinishedDelegate: class {
    func childIsDone(coordinator: Coordinator)
}

protocol WorkIsDoneDelegate: class {
    func done(cooridinator: Coordinator)
}
