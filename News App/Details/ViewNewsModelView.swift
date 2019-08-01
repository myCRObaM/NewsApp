//
//  ViewNewsModelView.swift
//  News App
//
//  Created by Matej Hetzel on 30/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RealmSwift
import RxSwift

class ViewNewsModelView {
    var loadednews: Article!
    var starSubject = PublishSubject<Bool>()
    var starInitSubject = PublishSubject<Bool>()
    var buttonIsPressedDelegate: ButtonPressDelegate?
    var changeFavoriteStateDelegate: FavoriteDelegate?
    
    func loadDataToViewModel(news: Article){
        self.loadednews = news
    }

    
    func configureStars(subject: PublishSubject<Bool>) -> Disposable{
        return subject.flatMap({ (bool) -> Observable<Bool> in
            return Observable.just(bool)
        }).observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.starSubject.onNext(self.loadednews.isFavorite ?? false)
            })
    }
    
}
