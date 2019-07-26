//
//  FavoriteDelegate.swift
//  News App
//
//  Created by Matej Hetzel on 19/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit

protocol FavoriteDelegate {
    func changeFavoriteState(news: Article)
}
