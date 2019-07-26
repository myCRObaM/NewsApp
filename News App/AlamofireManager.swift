//
//  AlamofireRequest.swift
//  News App
//
//  Created by Matej Hetzel on 25/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import RxCocoa

class AlamofireManager {
    
    func requestData() -> Observable<[Article]>{
        return Observable.create{ observer -> Disposable in
            let url = URL(string: "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=6946d0c07a1c4555a4186bfcade76398")!
            Alamofire.request(url)
                .responseJSON { response in
                    do{
                        guard let data = response.data else {return}
                        let articles = try JSONDecoder().decode(News.self, from: data)
                        observer.onNext(articles.articles)
                        observer.onCompleted()
                    } catch let jsonErr {
                        print("Error serializing json ", jsonErr)
                        observer.onError(jsonErr)
                    }
            }
            
            return Disposables.create()
        }
    }
}
