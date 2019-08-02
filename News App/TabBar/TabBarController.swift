//
//  TabBarController.swift
//  News App
//
//  Created by Matej Hetzel on 17/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    func setupAppearance() {
        let navAppearance = UINavigationBar.appearance()
        navAppearance.barTintColor = UIColor(red: 0.24, green: 0.31, blue: 0.71, alpha: 1)
        navAppearance.tintColor = .white
    }
}
extension TabBarCoordinator: FavoriteDelegate {
    func changeFavoriteState(news: Article){
        allNewsViewController.changeFavorite(news: news)
        favoriteNewsViewController.changeFavorite(news: news)
    }
}
