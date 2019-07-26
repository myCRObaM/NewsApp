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
        let sourceOfObservables = Observable.of(allNewsViewController.rxIsFavorite.asObservable(), favoriteNewsViewController.rxIsFavorite.asObservable())
            sourceOfObservables.merge()
            .distinctUntilChanged({  (a, b) -> Bool in
                if (a.urlToImage != b.urlToImage || a.isFavorite != b.isFavorite) {return false}
                else {return true}
            })
            .subscribe(onNext: { [weak self] in
                print($0.isFavorite as Any)
                self!.changeFavoriteState(news: $0)
            }).disposed(by: disposeBag)
        
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
        if !compareRealmObject(news: news) {
            addToFavorites(news: news)
        }
        else {
            removeFromFavorites(news: news)
        }
    }
    
    func addToFavorites(news: Article){
        
        favoriteNewsViewController.news.append(Article(title: news.title, description: news.description, urlToImage: news.urlToImage, isFavorite: true))
        guard let favNewsIndex = favoriteNewsViewController.news.firstIndex(where: {$0.urlToImage == news.urlToImage}) else {return}
        let newIndexPath: IndexPath = IndexPath(row: favNewsIndex, section: 0)
        favoriteNewsViewController.tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        guard let allNewsIndexOfCell = allNewsViewController.newsloaded.firstIndex(where: {$0.urlToImage == news.urlToImage}) else {return}
        let newIndexOfCell: IndexPath = IndexPath(row: allNewsIndexOfCell, section: 0)
        allNewsViewController.newsloaded[allNewsIndexOfCell].isFavorite = true
        
        realmManager.addobjToRealm(usedNew: Article(title: news.title, description: news.description, urlToImage: news.urlToImage, isFavorite: true))
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { data in
                print(data)
            }).disposed(by: disposeBag)
        allNewsViewController.tableView.reloadRows(at: [newIndexOfCell], with: .automatic)
    }
    
    func removeFromFavorites(news: Article){
        
        guard let allNews = allNewsViewController.newsloaded.firstIndex(where: {$0.urlToImage == news.urlToImage}) else {return}
        let newAllNewsIndex: IndexPath = IndexPath(row: allNews, section: 0)
        allNewsViewController.newsloaded[allNews].isFavorite = false
        
        realmManager.deleteObject(usedNew: news)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { data in
                print(data)
            }).disposed(by: disposeBag)
        allNewsViewController.tableView.reloadRows(at: [newAllNewsIndex], with: .automatic)
        
        guard let newsindex = favoriteNewsViewController.news.firstIndex(where: {$0.urlToImage == news.urlToImage}) else {return}
        let newIndexPath: IndexPath = IndexPath(row: newsindex, section: 0)
        favoriteNewsViewController.news.remove(at: newsindex)
        favoriteNewsViewController.tableView.deleteRows(at: [newIndexPath], with: .automatic)
        
       
    }
    
    func compareRealmObject(news: Article) -> Bool{
        
        for index in realmObject{
            if index.urlToImg == news.urlToImage{
                return true
            }
        }
        return false
    }
    
}

