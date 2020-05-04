//
//  HeadLinesViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class HeadLinesViewController: BaseViewController {
    
    @IBOutlet weak var headlineTableView: UITableView! {
        didSet {
            let refresh = UIRefreshControl()
            refresh.tintColor = .black
            self.headlineTableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    var articlesArray = [DiscoverViewModel]()
    var totalCount = 38
    var pageNo = 1
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        registerNib()
        fetchTopHeadLines(for: pageNo)
    }
    
    func setUp() {
        headlineTableView.estimatedRowHeight = 435
        headlineTableView.rowHeight = UITableView.automaticDimension
        headlineTableView.tableFooterView = UIView()
        headlineTableView.hideTableView(true)
    }
    
    func registerNib() {
        headlineTableView.register(UINib(nibName: ArticlesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        headlineTableView.register(UINib(nibName: LoaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoaderTableViewCell.identifier)
    }
    
    @objc func refreshHandler() {
        pageNo = 1
        isLoading = false
        self.headlineTableView.refreshControl?.beginRefreshing()
        fetchTopHeadLines(for: pageNo, clearArray: true, isResfresh: true)
    }
    
    func fetchTopHeadLines(for PageNo: Int, clearArray: Bool=false, isResfresh: Bool=false) {
        HeadLinesService().fetchTopHeadLines(for: PageNo, result: { [weak self](response) in
            if clearArray {
                self?.articlesArray.removeAll()
            }
            DispatchQueue.main.async {
                for values in response {
                    self?.articlesArray.append(DiscoverViewModel(articles: values))
                }
                self?.pageNo += 1
                self?.isLoading = true
                if isResfresh {
                    self?.headlineTableView.refreshControl?.endRefreshing()
                }
                self?.headlineTableView.reloadData()
                self?.headlineTableView.hideTableView(false)
                
            }
        }) { [weak self](message) in
            if isResfresh {
                self?.headlineTableView.refreshControl?.endRefreshing()
            }
            self?.isLoading = false
            self?.displayAlert(title: "Error", message: message)
        }
    }
}

extension HeadLinesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.articlesArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
            let details = articlesArray[indexPath.row]
            cell.setUpValues(details: details)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier) as! LoaderTableViewCell
            if isLoading {
                if self.totalCount != self.articlesArray.count {
                    cell.activityIndicator.startAnimating()
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        print("PageNo: \(self.pageNo)")
                        self.fetchTopHeadLines(for: self.pageNo, clearArray: false)
                    }
                }
                else {
                    isLoading = false
                    cell.activityIndicator.stopAnimating()
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.articlesArray.count {
            return UITableView.automaticDimension
        }
        else {
            if isLoading {
                if self.totalCount != self.articlesArray.count {
                    return UITableView.automaticDimension
                }
                else {
                    return 0
                }
            }
            else {
                return 0
            }
        }
    }
}
