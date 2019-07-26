//
//  NewsFavorite.swift
//  News App
//
//  Created by Matej Hetzel on 17/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import RealmSwift

class NewsFavorite: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var descr = ""
    @objc dynamic var urlToImg = ""
    @objc dynamic var isFavorite = true
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
