//
//  TabBarController.swift
//  News App
//
//  Created by Matej Hetzel on 17/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa


class TabBarController: UITabBarController {
    let realmManager = RealmManager()
    var realmObject: Results<NewsFavorite>!
    let buttonPressDelegate = ButtonPressDelegate?.self
    let changeFavoritesDelegate = FavoriteDelegate?.self
    let disposeBag = DisposeBag()
    
    let allNewsViewController: NewsTableViewController = {
        var navController = NewsTableViewController()
        navController.title = "News feed"
        navController.tabBarItem.image = UIImage(named: "note")
        return navController
    }()
    let navController: UINavigationController = {
        var navController = UINavigationController()
        return navController
    }()
    let favoriteNewsNavController: UINavigationController = {
        var navController = UINavigationController()
        return navController
    }()
    let favoriteNewsViewController: FavoriteNewsViewController = {
        var FavoriteViewControllers = FavoriteNewsViewController()
        FavoriteViewControllers.title = "Favorites"
        FavoriteViewControllers.tabBarItem.image = UIImage(named: "list")
        return FavoriteViewControllers
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
        setViewControllers()
    }
    func loadFavorites(){
        realmManager.loadRealmData()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self]value in
                self.realmObject = value
            }).disposed(by: disposeBag)
    }
    
    func setViewControllers() {

        let navAppearance = UINavigationBar.appearance()
        navController.viewControllers = [allNewsViewController]
        allNewsViewController.changeFavoriteStateDelegate = self
        favoriteNewsViewController.changeFavoriteStateDelegate = self
        favoriteNewsNavController.viewControllers = [favoriteNewsViewController]
        
        navAppearance.barTintColor = UIColor(red: 0.24, green: 0.31, blue: 0.71, alpha: 1)
        navAppearance.tintColor = .white
        viewControllers = [navController, favoriteNewsNavController]
        
        
    }
    
}
extension TabBarController: FavoriteDelegate {
    func changeFavoriteState(news: Article){
        allNewsViewController.changeFavorites(news: news)
        favoriteNewsViewController.changeFavorite(news: news)
    }
}

