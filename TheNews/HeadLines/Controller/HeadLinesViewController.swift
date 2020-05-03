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
    
    var articlesArray = [ArticleModel]()
    var totalCount = 100
    var pageCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchTopHeadLines(for: 1, clearArray: true)
    }
    
    func setUp() {
        headlineTableView.rowHeight = 405
        headlineTableView.estimatedRowHeight = UITableView.automaticDimension
        headlineTableView.tableFooterView = UIView()
    }
    
    func fetchTopHeadLines(for PageNo: Int, clearArray: Bool) {
        HeadLinesService().fetchTopHeadLines(for: PageNo, result: { [weak self](response) in
            if clearArray {
                self?.articlesArray.removeAll()
            }
            DispatchQueue.main.async {
                for values in response {
                    self?.articlesArray.append(values)
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
