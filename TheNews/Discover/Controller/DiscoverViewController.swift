//
//  DiscoverViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {
    @IBOutlet weak var colvw: UICollectionView! {
        didSet {
            colvw.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var discoverTableView: UITableView! {
        didSet {
            discoverTableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 60, right: 0)
            let refresh = UIRefreshControl()
            refresh.tintColor = UIColor(named: "DarkPink")
            self.discoverTableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    @IBOutlet weak var scrollToTopButton: UIButton?
    @IBOutlet weak var scrollToTopTrailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var vwColTopConstraint: NSLayoutConstraint?
    
    
    var scrollToTop = false
    private var vwModel = DiscoverViewModel()
    private var offsetCondition: CGFloat = UIDevice.current.hasNotch ? 200 : 176

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setUpView()
        vwModel.fetchDiscoverList()
        vwModel.refreshUI = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.discoverTableView.refreshControl?.endRefreshing()
                self.discoverTableView.reloadData()
            }
        }
    }
    
    func setUpView() {
        scrollToTopButton?.alpha = 0
    }
    
    func registerNib() {
        colvw.register(UINib(nibName: CategoryCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        discoverTableView.register(UINib(nibName: ArticlesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTableViewCell.identifier)
        discoverTableView.register(UINib(nibName: LoaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoaderTableViewCell.identifier)
    }
    
    @objc func refreshHandler() {
        self.discoverTableView.refreshControl?.beginRefreshing()
        vwModel.offset = 1
        vwModel.fetchDiscoverList(clearArray: true)
    }
    
    @IBAction func scrollToTop(_ sender: UIButton) {
        if vwModel.articleList.count != 0 {
            UIView.animate(withDuration: 0.5) {
                self.discoverTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
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
                        self.discoverTableView.beginUpdates()
                        self.discoverTableView.endUpdates()
                    }
                }
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoaderTableViewCell.identifier) as! LoaderTableViewCell
                cell.activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.vwModel.fetchDiscoverList()
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
        if scrollView == colvw { return }
        if offsetY >= -offsetCondition { //-176
            vwColTopConstraint?.constant = 0
        } else {
            vwColTopConstraint?.constant = -discoverTableView.contentOffset.y - offsetCondition
        }
        
        
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
        if scrollToTopButton == nil { return }
        if isHidden {
            self.scrollToTopTrailingConstraint?.constant = -80
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.scrollToTopButton?.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            self.scrollToTopTrailingConstraint?.constant = 20
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.scrollToTopButton?.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vwModel.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.lblCategory.text = vwModel.categoryList[indexPath.row].uppercased()
        cell.toggleSelection(vwModel.toggleCategorySelection(for: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !vwModel.isSameCategorySelected(index: indexPath.row) {
            let cell = colvw.cellForItem(at: indexPath) as? CategoryCell
            vwModel.selectedCategory = vwModel.categoryList[indexPath.row]
            cell?.toggleSelection(vwModel.toggleCategorySelection(for: indexPath.row))
            colvw.reloadData()
            colvw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.discoverTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.vwModel.fetchDiscoverList(clearArray: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = vwModel.categoryList[indexPath.row]
        return CGSize(width: category.widthOfString() + 50, height: 40)
    }
    
    
}
