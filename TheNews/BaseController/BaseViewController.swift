//
//  BaseViewController.swift
//  TheNews
//
//  Created by DS on 03/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = getRightBarButton()
        navigationItem.searchController = getSearchInNavbar()
        if Global.shared.currentScreenType == .search {
            layoutCustomizationToNavBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCustomizationToNavBar()
    }
    
    func getRightBarButton() -> UIBarButtonItem? {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onTapProfileButton))
        button.tintColor = UIColor.gray
        if let image = Global.shared.userObj?.image {
            UIImageView().kf.setImage(with: URL(string: image), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil) { [weak self](result) in
                if let _ = self {
                    switch result {
                    case .success(let response) :
                        button.image = response.image.circularImage(withSize: nil)?.withRenderingMode(.alwaysOriginal)
                    case .failure(let error):
                        button.image = #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysOriginal)
                        print("ImageFailedToLoad: \(String(describing: error.errorDescription))")
                    }
                }
            }
        }
        return button
    }
    
    func getSearchInNavbar()-> UISearchController? {
        if Global.shared.currentScreenType == .search {
            //self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            self.navigationItem.hidesSearchBarWhenScrolling = false
            let search = UISearchController(searchResultsController: nil)
            search.dimsBackgroundDuringPresentation = false
            search.searchResultsUpdater = self
            return search
        }
        else {
            return nil
        }
    }
    
    func layoutCustomizationToNavBar() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.shadowImage = UIImage()
        if Global.shared.currentScreenType != .search {
            self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
            self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
            self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.navigationController?.navigationBar.layer.shadowRadius = 2
        }
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    
    @objc func onTapProfileButton() {
        displayAlertWithAction(title: "SignOut!", cancelButtonName: "No", message: "Do you want to Signout?", actionButtonName: "Yes, Sign me out") {
            GIDSignIn.sharedInstance().signOut()
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.setRootController()
        }
    }
    
}

extension BaseViewController: CellDelegate {
    func didTapSourceButton(with url: String) {
        let vc = StoryBoardManager.shared.getStoryboard(name: .Source).instantiateViewController(withIdentifier: SourceWebViewController.identifier) as! SourceWebViewController
        vc.sourcelUrl = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BaseViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
    }
    
    
    
}
