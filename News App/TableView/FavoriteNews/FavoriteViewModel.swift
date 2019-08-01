//
//  FavoriteViewModel.swift
//  News App
//
//  Created by Matej Hetzel on 30/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift

class FavoriteViewModel {
    let manageRealm = RealmManager()
    var realmObject: Results<NewsFavorite>!
    var articleSubjectAdd = PublishSubject<Article>()
    var articleSubjectRemove = PublishSubject<Article>()
    var favoriteChangeSubject = PublishSubject<favoriteChangeEnum>()
    var brojacUcitavanja: Int = 0
    var news = [Article]()
    var loadFavoritesSubject = PublishSubject<Bool>()
    
    
    func fillData() {
        for index in realmObject{
            news.append(Article(title: index.title, description: index.descr, urlToImage: index.urlToImg, isFavorite: true))
        }
    }
    
    func getData() -> Disposable{
        return manageRealm.loadRealmData()
            .subscribe(onNext: { [unowned self]value in
                self.realmObject = value
                self.fillData()
            })
    }
    
    func addFavorites(subject: PublishSubject<Article>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] newss in
                self.news.append(Article(title: newss.title, description: newss.description, urlToImage: newss.urlToImage, isFavorite: true))
                let favNewsIndex = self.news.firstIndex(where: {$0.urlToImage == newss.urlToImage})
                let newIndexOfCell: IndexPath = IndexPath(row: favNewsIndex ?? -1, section: 0)
                self.favoriteChangeSubject.onNext(favoriteChangeEnum.add([newIndexOfCell]))
            })
    }
    
    func removeFavorites(subject: PublishSubject<Article>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({newss -> (Int, IndexPath) in
                let newsIndex = self.returnIndexPathForCell(newss: newss)
                let newIndexPath: IndexPath = IndexPath(row: newsIndex, section: 0)
                return (newsIndex, newIndexPath)
            })
            .subscribe(onNext: { [unowned self] newsIndex, newIndexPath in
                self.news.remove(at: newsIndex)
                self.favoriteChangeSubject.onNext(favoriteChangeEnum.remove([newIndexPath]))
            })
    }
    
    func changeFavorite(newss: Article){
        if newss.isFavorite ?? false {
            articleSubjectRemove.onNext(newss)
        }
        else {
            articleSubjectAdd.onNext(newss)
        }
    }

    func returnIndexPathForCell(newss: Article) -> Int{
        guard let allNewsIndexOfCell = news.enumerated().first(where: { (data) -> Bool
            in data.element.urlToImage == newss.urlToImage
        }) else {return -1}
        return allNewsIndexOfCell.offset
    }
}
