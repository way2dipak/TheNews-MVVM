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
    @IBOutlet weak var discoverTableView: UITableView!
    
    var articleArray = [DiscoverViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setUpView()
        fetchNews(for: 1)
    }
    
    func setUpView() {
        discoverTableView.hideTableView(true)
        discoverTableView.estimatedRowHeight = UITableView.automaticDimension
        discoverTableView.rowHeight = 447.5
        discoverTableView.tableFooterView = UIView()
    }
    
    func registerNib() {
        discoverTableView.register(UINib(nibName: ArticlesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
    }
    
    func fetchNews(for pageNo: Int) {
        DiscoverService().fetchDiscover(for: pageNo, result: { [weak self](articles) in
            self?.articleArray = articles.map({ return DiscoverViewModel(articles: $0) })
            DispatchQueue.main.async {
                self?.discoverTableView.reloadData()
                self?.discoverTableView.hideTableView(false)
            }
        }) { [weak self](error) in
            self?.displayAlert(title: "Error", message: error)
            print("Error: \(error)")
        }
    }

    override func onTapProfileButton() {
        displayAlertWithAction(title: "SignOut!", cancelButtonName: "No", message: "Do you want to Signout?", actionButtonName: "Yes, Sign me out") {
            GIDSignIn.sharedInstance().signOut()
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.setRootController()
        }
    }
    
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.identifier) as! ArticlesTableViewCell
        let details = articleArray[indexPath.row]
        cell.setUpValues(details: details)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
