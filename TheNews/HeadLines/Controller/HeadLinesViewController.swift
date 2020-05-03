//
//  HeadLinesViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit


class HeadLinesViewController: BaseViewController {
    
    
    @IBOutlet weak var headlineTableView: UITableView!
    
    var articlesArray = [DiscoverViewModel]()
    var totalCount = 38
    var pageCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        registerNib()
        //fetchTopHeadLines(for: 1, clearArray: true)
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
    
    func fetchTopHeadLines(for PageNo: Int, clearArray: Bool) {
        HeadLinesService().fetchTopHeadLines(for: PageNo, result: { [weak self](response) in
            if clearArray {
                self?.articlesArray.removeAll()
            }
            DispatchQueue.main.async {
                for values in response {
                    self?.articlesArray.append(DiscoverViewModel(articles: values))
                }
                self?.pageCount += 1
                self?.headlineTableView.reloadData()
                self?.headlineTableView.hideTableView(false)
                
            }
        }) { [weak self](message) in
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
            if self.totalCount != self.articlesArray.count {
                cell.activityIndicator.startAnimating()
                //cell.activityIndicator.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    print("PageNo: \(self.pageCount)")
                    self.fetchTopHeadLines(for: self.pageCount, clearArray: false)
                }
            }
            else {
                cell.activityIndicator.stopAnimating()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.articlesArray.count {
            return UITableView.automaticDimension
        }
        else {
            if self.totalCount != self.articlesArray.count {
                return UITableView.automaticDimension
            }
            else {
                return 0
            }
        }
    }
}
