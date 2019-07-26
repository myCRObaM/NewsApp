//
//  ViewNewsController.swift
//  News App
//
//  Created by Matej Hetzel on 15/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import RxSwift

class ViewNewsController: UIViewController {
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "Default")
        return imageView
    }()
    let newsTitleView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let newsArticleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        return label
    }()
    let navBarTitleLabel:  UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        return titleLabel
    }()
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "NavBarStar"), for: .normal)
        button.setImage(UIImage(named: "NavBarStarFull"), for: .selected)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    
    var loadednews: Article?
    var realmObject: Results<NewsFavorite>!
    let disposeBag = DisposeBag()
    var realmManager = RealmManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
        setupUI()
        setupView()
    }
    func loadFavorites(){
        realmManager.loadRealmData()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self]value in
                self.realmObject = value
            }).disposed(by: disposeBag)
    }
    
    func setupUI(){
        view.addSubview(newsImageView)
        view.addSubview(newsTitleView)
        view.addSubview(newsArticleView)
        navBarTitleLabel.text = loadednews?.title
        navigationItem.titleView = navBarTitleLabel

        favoriteButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        setupConstraints()
        
        starSetup()
    }
    func starSetup() {
        if loadednews != nil {
            favoriteButton.isSelected = loadednews?.isFavorite ?? false
        }
    }
    @objc func addTapped(){
        if loadednews != nil {
            if loadednews?.isFavorite ?? false {
                loadednews?.isFavorite = false
            }
            else {loadednews?.isFavorite = true}
        }
        
        starSetup()
    }
    
    func setupConstraints(){
        
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        
        newsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        
        newsTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        newsTitleView.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 20).isActive = true
        newsTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        
        
        newsArticleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        newsArticleView.topAnchor.constraint(equalTo: newsTitleView.bottomAnchor, constant: 20).isActive = true
        newsArticleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    func setupView(){
        newsImageView.kf.setImage(with: URL(string: loadednews!.urlToImage))
        newsTitleView.text = loadednews?.title
        newsArticleView.text = loadednews?.description
        
    }
    
    
    
}
