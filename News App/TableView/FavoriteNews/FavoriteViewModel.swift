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
    var changeFavoriteSubject = PublishSubject<Article>()
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
    
    func changeFavorite(subject: PublishSubject<Article>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] newss -> (Int, IndexPath) in
                if newss.isFavorite ?? false {
                    let newsIndex = self.returnIndexPathForCell(newss: newss)
                    let newIndexPath: IndexPath = IndexPath(row: newsIndex, section: 0)
                    self.news.remove(at: newsIndex)
                    self.favoriteChangeSubject.onNext(favoriteChangeEnum.remove([newIndexPath]))
                    return (newsIndex, newIndexPath)
                } else {
                    self.news.append(Article(title: newss.title, description: newss.description, urlToImage: newss.urlToImage, isFavorite: true))
                    let favNewsIndex = self.returnIndexPathForCell(newss: newss)
                    let newIndexOfCell: IndexPath = IndexPath(row: favNewsIndex, section: 0)
                    self.favoriteChangeSubject.onNext(favoriteChangeEnum.add([newIndexOfCell]))
                    return (favNewsIndex, newIndexOfCell)
                }
            })
            .subscribe(onNext: { newsIndex, newIndexPath in
            })
    }

    func returnIndexPathForCell(newss: Article) -> Int{
        guard let allNewsIndexOfCell = news.enumerated().first(where: { (data) -> Bool
            in data.element.urlToImage == newss.urlToImage
        }) else {return -1}
        return allNewsIndexOfCell.offset
    }
}
