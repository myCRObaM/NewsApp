//
//  MealTableViewCell.swift
//  News App
//
//  Created by Matej Hetzel on 15/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import Kingfisher

class NewsTableViewCell: UITableViewCell{
    
    
    let tableView = UITableView()
    var loadednewss: Article!
    var favoriteID: Int = 0
    var rxIsFavorite = PublishSubject<Article>()
    private(set) var disposableBag = DisposeBag()
    var buttonIsPressed: () -> Void = {}
    
    let articleDisc: UILabel = {
        let nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    let artImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.image = UIImage(named: "Default")
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleToFill
        return photoImageView
    }()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star"), for: .normal)
        button.setImage(UIImage(named: "fullstar"), for: .selected)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(artImageView)
        contentView.addSubview(articleDisc)
        favoriteButton.addTarget(self, action: #selector(changeFavorites), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
        
        artImageView.heightAnchor.constraint(equalToConstant: 76).isActive = true
        artImageView.widthAnchor.constraint(equalToConstant: 76).isActive = true
        artImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        artImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        artImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        articleDisc.leadingAnchor.constraint(equalTo: artImageView.trailingAnchor, constant: 20).isActive = true
        articleDisc.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10).isActive = true
        articleDisc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        articleDisc.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setObject(news: Article){
        favoriteButton.isSelected = news.isFavorite ?? false
        artImageView.kf.setImage(with: URL(string: news.urlToImage))
        articleDisc.text = news.title
        loadednewss = Article(title: news.title, description: news.description, urlToImage: news.urlToImage, isFavorite: news.isFavorite)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposableBag = DisposeBag()
    }
    
    
    @objc func changeFavorites(){
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


