//
//  FavoriteNewsViewController.swift
//  News App
//
//  Created by Matej Hetzel on 17/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import RxSwift

class FavoriteNewsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
  
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let titleLabel:  UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = "Favorites"
        
        return titleLabel
    }()
    
    
    
    let manageRealm = RealmManager()
    var realmObject: Results<NewsFavorite>!
    var brojacUcitavanja: Int = 0
    var news = [Article]()
    var disposeBag = DisposeBag()
    var rxIsFavorite = PublishSubject<Article>()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
        setupTableView()
        fillData()
    }
    
    func loadFavorites(){
        manageRealm.loadRealmData()
            .subscribe(onNext: { [unowned self]value in
                self.realmObject = value
            }).disposed(by: disposeBag)
    }
    
    func fillData() {
        for index in realmObject{
            news.append(Article(title: index.title, description: index.descr, urlToImage: index.urlToImg, isFavorite: true))
        }
    }
    
    func setupTableView(){
    tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "CellID")
    tableView.dataSource = self
    tableView.delegate = self
    self.navigationItem.titleView = titleLabel
    view.addSubview(tableView)
    TableViewContraints()
    }
    
    func TableViewContraints(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? NewsTableViewCell else {
            fatalError("Nije instanca ")
        }
        var realmObjWithIndex = news[indexPath.row]
        realmObjWithIndex.isFavorite = returnBool(IzRealmaUObj: realmObjWithIndex)
        
        cell.favoriteButton.rx.tap
            .bind { [weak self] in
                self?.rxIsFavorite.onNext(realmObjWithIndex)
            }.disposed(by: cell.disposableBag)
        
        cell.setObject(news: realmObjWithIndex)
        return cell
    }
    
    func returnBool(IzRealmaUObj: Article)-> Bool{
        for objectIndex in realmObject
        {
            if objectIndex.urlToImg == IzRealmaUObj.urlToImage {
                return true
                
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){        let newsController = ViewNewsController(nibName: nil, bundle: nil)
        newsController.loadednews = news[indexPath.row]
        newsController.favoriteButton.rx.tap
            .bind { [weak self] in
                self?.rxIsFavorite.onNext((self?.news[indexPath.row])!)
            }.disposed(by: newsController.disposeBag)
        navigationController?.pushViewController(newsController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
}


