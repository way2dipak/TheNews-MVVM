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
            headlineTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            let refresh = UIRefreshControl()
            refresh.tintColor = UIColor(named: "DarkPink")
            self.headlineTableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    @IBOutlet weak var scrollToTopButton: UIButton!
    @IBOutlet weak var scrollToTopTrailingConstraint: NSLayoutConstraint!
    
    var scrollToTop = false
    private var vwModel = HeadLineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        registerNib()
        vwModel.fetchTopHeadlines()
        vwModel.refreshUI = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.headlineTableView.refreshControl?.endRefreshing()
                self.headlineTableView.reloadData()
            }
        }
    }
    
    func setUp() {
        scrollToTopButton.alpha = 0
    }
    
    func registerNib() {
        headlineTableView.register(UINib(nibName: ArticlesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        headlineTableView.register(UINib(nibName: LoaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoaderTableViewCell.identifier)
    }
    
    @objc func refreshHandler() {
        self.headlineTableView.refreshControl?.beginRefreshing()
        vwModel.fetchTopHeadlines(clearArray: true)
    }
    @IBAction func scrollToTop(_ sender: UIButton) {
        if vwModel.articleList.count != 0 {
            UIView.animate(withDuration: 1.5) {
                self.headlineTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

extension HeadLinesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vwModel.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vwModel.getNumberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if vwModel.articleList.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
                cell.hideSkeleton(false)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
                if vwModel.articleList.count != 0 {
                    let details = vwModel.articleList[indexPath.row]
                    cell.details = details
                    cell.cellDelegate = self
                    cell.hideSkeleton()
                }
                
                cell.layoutHandler = { [weak self] in
                    guard let self = self else { return }
                    UIView.performWithoutAnimation {
                        self.headlineTableView.beginUpdates()
                        self.headlineTableView.endUpdates()
                    }
                }
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier) as! LoaderTableViewCell
                cell.activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.vwModel.fetchTopHeadlines()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 60
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
            self.scrollToTopTrailingConstraint.constant = -40
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
