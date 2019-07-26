//
//  ViewController.swift
//  News App
//
//  Created by Matej Hetzel on 15/07/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import RealmSwift
import RxSwift

class NewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    let titleLabel:  UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        return titleLabel
    }()
    var saveTime: Int = 0
    var savedTimeForRefresh = PublishSubject<String>()
    var afRequestDownloaded = PublishSubject<String>()
    private let refreshControl = UIRefreshControl()
    var newsloaded = [Article]()
    var realmObject: Results<NewsFavorite>!
    var rxIsFavorite = PublishSubject<Article>()
    var changeFavoriteStateDelegate: FavoriteDelegate?
    let realmManager = RealmManager()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        setupView()
        self.tableView.reloadData()
    }
    func loadFavorites(){
        realmManager.loadRealmData()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self]value in
                self.realmObject = value
            }).disposed(by: disposeBag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsloaded.count
    }
    
    var realmObjects: Results<NewsFavorite>!
    let realmClass = RealmManager()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        refresh()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? NewsTableViewCell else {
            fatalError("Nije instanca ")
        }
        let new = newsloaded[indexPath.row]
        cell.setObject(news: new)
        cell.buttonIsPressedDelegate = self
//        cell.favoriteButton.rx.tap
//            .bind { [weak self] in
//                self?.rxIsFavorite.onNext(new)
//        }.disposed(by: cell.disposableBag)
//        
        return cell
    }
    
    func objectBool(new: [Article]) {
        var counter: Int = 0
        for newsIndex in new{
            for realmIndex in realmObject{
                if realmIndex.urlToImg == newsIndex.urlToImage {
                    newsloaded[counter].isFavorite = true
                }
        }
        counter += 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let newsController = ViewNewsController(nibName: nil, bundle: nil)
        newsController.loadednews = newsloaded[indexPath.row]
        newsController.favoriteButton.rx.tap
            .bind { [weak self] in
                self?.rxIsFavorite.onNext((self?.newsloaded[indexPath.row])!)
        }.disposed(by: newsController.disposeBag)
        navigationController?.pushViewController(newsController, animated: true)
    }
    
    
    func setupTableView(){
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
    }
    func setupView(){
        setupTableView()
        titleLabel.text = "Factory"
        self.navigationItem.titleView = titleLabel
        
        setupConstraints()
     
    }
     
    
    func setupConstraints(){
        
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        refreshControlFunc()
        
    }
    func refreshControlFunc(){
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshApiData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing News Data")
    }
  
    
    func getData(){
        savedTimeForRefresh
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { conformation in
                //print(conformation)
                let alamofireObject = AlamofireManager()
                alamofireObject.requestData()
                    .observeOn(MainScheduler.instance)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribe(onNext: { [unowned self] article in
                        self.newsloaded = article
                        let date = Date()
                        self.objectBool(new: self.newsloaded)
                        self.refreshControl.endRefreshing()
                        self.saveTime = Int(date.timeIntervalSince1970)
                        self.afRequestDownloaded.onNext("Skinuto")
                    }
                    ).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        afRequestDownloaded
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] downloaded in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func refresh(){
        let date = Date()
        if saveTime + 300 < Int(date.timeIntervalSince1970) || saveTime == 0{
            getData()
            savedTimeForRefresh.onNext("Download")
        }
        
    }
    
    
   func popUpError(){
    
    let alert = UIAlertController(title: "Greška", message: "Ups, došlo je do pogreške.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "U redu", style: .default, handler: nil))
    
    self.present(alert, animated: true)
    
    }
    
    @objc private func refreshApiData(_ sender: Any) {
        getData()
        savedTimeForRefresh.onNext("Download")
    }
 
}
extension NewsTableViewController: ButtonPressDelegate{
    func buttonIsPressed(new: Article) {
        changeFavoriteStateDelegate?.changeFavoriteState(news: new)
    }
}





