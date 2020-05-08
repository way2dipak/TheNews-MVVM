//
//  SearchViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            let refresh = UIRefreshControl()
            refresh.tintColor = .black
            self.searchTableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var scrollToTopButton: UIButton!
    @IBOutlet weak var scrollToTopTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var defaultImageView: UIImageView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var articleArray = [DiscoverViewModel]()
    var pageNo = 1
    var totalCount = 0
    var isLoading: Bool = false
    var scrollToTop = false
    var query = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScreenType = .search
        searchController.searchBar.delegate = self
        registerNib()
        setUpView()
        //getSearchResults(for: pageNo)
    }
    
    func setUpView() {
        searchTableView.hideTableView(true)
        searchTableView.estimatedRowHeight = 500
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.tableFooterView = UIView()
        scrollToTopButton.alpha = 0
    }
    
    func registerNib() {
        searchTableView.register(UINib(nibName: ArticlesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        searchTableView.register(UINib(nibName: LoaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoaderTableViewCell.identifier)
    }
    
    @objc func refreshHandler() {
        if query != "" {
            pageNo = 1
            isLoading = false
            self.searchTableView.refreshControl?.beginRefreshing()
            getSearchResults(with: query, for: pageNo, clearArray: true, isResfresh: true)
        }
    }
    
    func getSearchResults(with query: String, for pageNo: Int, clearArray: Bool=false, isResfresh: Bool=false) {
        SearchService().fetchResults(with: query, for: pageNo, result: { [weak self](articles, totalCounts) in
            if clearArray {
                self?.articleArray.removeAll()
            }
            for values in articles {
                self?.articleArray.append(DiscoverViewModel(articles: values))
            }
            DispatchQueue.main.async {
                self?.totalCount = totalCounts
                self?.pageNo += 1
                self?.isLoading = true
                if isResfresh {
                    self?.searchTableView.refreshControl?.endRefreshing()
                }
                self?.searchTableView.reloadData()
                self?.defaultImageView.hideView(true)
                self?.searchTableView.hideTableView(false)
            }
        }) { [weak self](message) in
            if isResfresh {
                DispatchQueue.main.async {
                    self?.searchTableView.refreshControl?.endRefreshing()
                }
            }
            self?.isLoading = false
            if message != "" {
                self?.displayAlert(title: "Error", message: message)
            }
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
            }
        }
    }
    
    @IBAction func scrollToTop(_ sender: UIButton) {
        if articleArray.count != 0 {
            searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        query = searchText
        if query.count >= 4 {
            self.pageNo = 1
          self.getSearchResults(with: query, for: pageNo, clearArray: true)
        }
    }
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.searchTextField.text = query
        searchBar.setShowsCancelButton(false, animated: true)
        scrollToTop(UIButton())
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < articleArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
            let details = articleArray[indexPath.row]
            cell.setUpValues(details: details)
            cell.cellDelegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier) as! LoaderTableViewCell
            if isLoading {
                if self.totalCount != self.articleArray.count {
                    cell.activityIndicator.startAnimating()
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        self.getSearchResults(with: self.query, for: self.pageNo)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        scrollViewDidScroll(with: offsetY)
        if offsetY > 400 {
            if scrollToTop {
                hideScrollButton(isHidden: false)
                scrollToTop = false
            }
        }
        else {
            if !scrollToTop {
                hideScrollButton(isHidden: true)
                scrollToTop = true
            }
        }
    }
    
    func hideScrollButton(isHidden: Bool) {
        if isHidden {
            self.scrollToTopTrailingConstraint.constant = -80
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.scrollToTopButton.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            self.scrollToTopTrailingConstraint.constant = 20
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.scrollToTopButton.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

