//
//  DiscoverViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import GoogleSignIn

class DiscoverViewController: BaseViewController {
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var discoverTableView: UITableView! {
        didSet {
            let refresh = UIRefreshControl()
            refresh.tintColor = .black
            self.discoverTableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    var articleArray = [DiscoverViewModel]()
    var pageNo = 1
    var totalCount = 100
    var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setUpView()
        fetchNews(for: pageNo)
    }
    
    func setUpView() {
        discoverTableView.hideTableView(true)
        discoverTableView.estimatedRowHeight = 500
        discoverTableView.rowHeight = UITableView.automaticDimension
        discoverTableView.tableFooterView = UIView()
    }
    
    func registerNib() {
        discoverTableView.register(UINib(nibName: ArticlesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        discoverTableView.register(UINib(nibName: LoaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoaderTableViewCell.identifier)
    }
    
    @objc func refreshHandler() {
        pageNo = 1
        isLoading = false
        self.discoverTableView.refreshControl?.beginRefreshing()
        fetchNews(for: pageNo, clearArray: true, isResfresh: true)
    }
    
    func fetchNews(for pageNo: Int, clearArray: Bool=false, isResfresh: Bool=false) {
        print("pageNo == \(pageNo)")
        DiscoverService().fetchDiscover(for: pageNo, result: { [weak self](articles) in
            if clearArray {
                self?.articleArray.removeAll()
            }
            for values in articles {
                self?.articleArray.append(DiscoverViewModel(articles: values))
            }
            DispatchQueue.main.async {
                self?.pageNo += 1
                self?.isLoading = true
                if isResfresh {
                    self?.discoverTableView.refreshControl?.endRefreshing()
                }
                self?.discoverTableView.reloadData()
                self?.discoverTableView.hideTableView(false)
            }
        }) { [weak self](error) in
            if isResfresh {
                self?.discoverTableView.refreshControl?.endRefreshing()
            }
            self?.isLoading = false
            self?.displayAlert(title: "Error", message: error)
            print("Error: \(error)")
        }
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < articleArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
            let details = articleArray[indexPath.row]
            cell.setUpValues(details: details)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier) as! LoaderTableViewCell
            if isLoading {
                if self.totalCount != self.articleArray.count {
                    cell.activityIndicator.startAnimating()
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        print("PageNo: \(self.pageNo)")
                        self.fetchNews(for: self.pageNo)
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
        if indexPath.row < articleArray.count {
            return UITableView.automaticDimension
        }
        else {
            if isLoading {
                if self.totalCount != self.articleArray.count {
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
