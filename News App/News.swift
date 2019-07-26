//
//  News.swift
//  News App
//
//  Created by Matej Hetzel on 15/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit

class News: Decodable {
        let status: String
        let source: String
        let sortBy: String
        let articles: [Article]
    
    

}
struct Article: Decodable {
    let title: String
    let description: String
    let urlToImage: String
    var isFavorite: Bool? = false
}
