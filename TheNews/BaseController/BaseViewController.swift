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

enum ScreenType {
    case discover
    case search
    case headlines
    case more
    case source
    case none
}



class BaseViewController: UIViewController {
    
    var currentScreenType: ScreenType = .discover
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = getRightBarButton()
        navigationItem.searchController = getSearchInNavbar()

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
        if currentScreenType == .search {
            //self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            self.navigationItem.hidesSearchBarWhenScrolling = false
            let search = UISearchController(searchResultsController: nil)
            search.dimsBackgroundDuringPresentation = false
            search.searchBar.delegate = self
            //search.searchResultsUpdater = self
            return search
        }
        else {
            return nil
        }
    }
    
    func layoutCustomizationToNavBar() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
//        if Global.shared.currentScreenType != .search {
//            self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
//            self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
//            self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
//            self.navigationController?.navigationBar.layer.shadowRadius = 2
//        }
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(with offsetY: CGFloat) {
        if offsetY > -80.0 {
            addShadowToNavigationBar(addShadow: true)
        }
        else {
            addShadowToNavigationBar(addShadow: false)
        }
    }
    
    func addShadowToNavigationBar(addShadow: Bool) {
        if addShadow {
            layoutCustomizationToNavBar()
            self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
            self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
            self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.navigationController?.navigationBar.layer.shadowRadius = 2
        }
        else {
            layoutCustomizationToNavBar()
            self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        }
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
        vc.currentScreenType = .source
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension BaseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

