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
    
    
    let viewModel = FavoriteViewModel()
    var disposeBag = DisposeBag()
    var changeFavoriteStateDelegate: FavoriteDelegate?
    var selectedDetailsDelegate: DetailsNavigationDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData().disposed(by: disposeBag)
        viewModel.changeFavorite(subject: viewModel.changeFavoriteSubject).disposed(by: disposeBag)
        editFavoriteRows()
        setupTableView()
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
        return viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realmObjWithIndex = viewModel.news[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? NewsTableViewCell else {
            fatalError("Nije instanca ")
        }
        
        cell.buttonIsPressedDelegate = self
        cell.configureCell(news: realmObjWithIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedDetailsDelegate?.openDetailsView(news: viewModel.news[indexPath.row])
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func editFavoriteRows(){
        viewModel.favoriteChangeSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [unowned self] isFavorite in
                switch isFavorite {
                case .add(let index):
                    self.tableView.insertRows(at: index, with: .automatic)
                case .remove(let index):
                    self.tableView.deleteRows(at: index, with: .automatic)
                }
            }).disposed(by: disposeBag)
    
}
    
    func changeFavorite(news: Article){
        viewModel.changeFavoriteSubject.onNext(news)
    }
    
}

extension FavoriteNewsViewController: ButtonPressDelegate{
    func buttonIsPressed(new: Article) {
        changeFavoriteStateDelegate?.changeFavoriteState(news: new)
    }
}

