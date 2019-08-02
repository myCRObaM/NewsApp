//
//  TableViewModel.swift
//  News App
//
//  Created by Matej Hetzel on 29/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RealmSwift


class TableViewModel {
    
    var saveTime: Int = 0
    var spinnerSubject = PublishSubject<LoaderEnum>()
    var getNewsSubject = PublishSubject<Bool>()
    var addNewsSubject = PublishSubject<Article>()
    var removeNewsSubject = PublishSubject<Article>()
    var changeFavoriteSubject = PublishSubject<Article>()
    var favoritesChanged = PublishSubject<[IndexPath]>()
    var errorWithLoading = PublishSubject<Bool>()
    var dataIsLoaded = PublishSubject<[Article]>()
    var refreshTableViewSubject = PublishSubject<Bool>()
    let realmObject = RealmManager()
    var newsloaded = [Article]()
    let disposeBag = DisposeBag()
    
    
    func setupFavoriteState(new: [Article], realm: Results<NewsFavorite>)-> [Article] {
        var finishedArray = [Article]()
    
        for (n, newsIndex) in new.enumerated(){
            finishedArray.append(newsIndex)
            for realmIndex in realm{
                if realmIndex.urlToImg == newsIndex.urlToImage {
                    finishedArray[n].isFavorite = true
                }
            }
        }
        return finishedArray
    }
    
    
    
    func getData(subject: PublishSubject<Bool>) -> Disposable{
        let alamofireObject = AlamofireManager()
        return subject.flatMap({[unowned self] (bool) -> Observable<(Results<NewsFavorite>, [Article])> in
            self.spinnerSubject.onNext(.addLoader)
            let observable = Observable.zip(self.realmObject.loadRealmData(), alamofireObject.requestData()) { (favorites, news) in
                return (favorites, news)
            }
            return observable
        })
            
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (article, realm) -> ([Article]) in
                let allNewsWithFavorites = self.setupFavoriteState(new: realm, realm: article)
                return allNewsWithFavorites
            })
            .subscribe(onNext: {article in
                self.newsloaded = article
                let date = Date()
                self.saveTime = Int(date.timeIntervalSince1970)
                self.spinnerSubject.onNext(.removeLoader)
                self.refreshTableViewSubject.onNext(true)
            }, onError: { [unowned self] error in
                self.errorWithLoading.onNext(true)
                print(error)
            })
    }
    
    func checkRefreshTime(){
        let date = Date()
        if saveTime + 300 < Int(date.timeIntervalSince1970) || saveTime == 0 || newsloaded.isEmpty{
            getNewsSubject.onNext(true)
        }
        
    }
    
    
    func changeFavorite(subject: PublishSubject<Article>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] newss -> (Int, IndexPath) in
                if newss.isFavorite ?? false {
                    let index = self.returnIndexPathForCell(news: newss)
                    self.newsloaded[index].isFavorite = false
                    let newIndexOfCell: IndexPath = IndexPath(row: index, section: 0)
                    self.favoritesChanged.onNext([newIndexOfCell])
                    return (index, newIndexOfCell)
                } else {
                    let newsIndex = self.returnIndexPathForCell(news: newss)
                    let newIndexPath: IndexPath = IndexPath(row: newsIndex, section: 0)
                    self.newsloaded[newsIndex].isFavorite = true
                    self.favoritesChanged.onNext([newIndexPath])
                    return (newsIndex, newIndexPath)
                }
            })
            .subscribe(onNext: { newsIndex, newIndexPath in
            })
    }
    
    func returnIndexPathForCell(news: Article) -> Int{
        guard let allNewsIndexOfCell = newsloaded.enumerated().first(where: { (data) -> Bool
            in data.element.urlToImage == news.urlToImage
        }) else {return -1}
        return allNewsIndexOfCell.offset
    }
    
}
