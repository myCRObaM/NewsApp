//
//  RealmManager.swift
//  News App
//
//  Created by Matej Hetzel on 17/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class RealmManager {
    
    
    
    func addobjToRealm(usedNew: Article) -> Observable<String> {
        let realmObject = NewsFavorite()
        realmObject.descr = usedNew.description
        realmObject.title = usedNew.title
        realmObject.urlToImg = usedNew.urlToImage
        realmObject.isFavorite = true
            do {
                let realm = try! Realm()
                print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
                try realm.write {
                    realm.add(realmObject)
                }
                return Observable.just("success")
            }catch{
                return Observable.just("Error adding object")
        }
    }
    
    func deleteObject(usedNew: Article) -> Observable<String>{
        let newz = NewsFavorite()
        newz.title = usedNew.title
        newz.descr = usedNew.description
        newz.urlToImg = usedNew.urlToImage
            do{
                let realm = try! Realm()
                try realm.write {
                    guard let SaKeyem = realm.object(ofType: NewsFavorite.self, forPrimaryKey: usedNew.title) else { return }
                    realm.delete(SaKeyem)
                }
                return Observable.just("success")
            }catch{
                return Observable.just("Error adding object")
            
        }

    }
    
    func loadRealmData() -> Observable<Results<NewsFavorite>>{
            let realm = try! Realm()
            let realmObject = realm.objects(NewsFavorite.self)
            return Observable.just(realmObject)
            }
}

