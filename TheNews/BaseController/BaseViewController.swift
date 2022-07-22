//
//  BaseViewController.swift
//  TheNews
//
//  Created by DS on 03/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //layoutCustomizationToNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getSearchInNavbar()-> UISearchController? {
        if self is CoronaViewController {
            return nil
        }
        else {
            //self.navigationController?.navigationItem.largeTitleDisplayMode = .never
            self.navigationItem.hidesSearchBarWhenScrolling = false
            let search = UISearchController(searchResultsController: nil)
           // search.dimsBackgroundDuringPresentation = false
            search.searchBar.delegate = self
            //search.searchResultsUpdater = self
            return search
        }
    }
    
    func layoutCustomizationToNavBar() {
        if self is CoronaViewController {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(with offsetY: CGFloat) {
        if offsetY > -80.0 {
            // addShadowToNavigationBar(addShadow: true)
        }
        else {
            //   addShadowToNavigationBar(addShadow: false)
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
        displayAlertWithAction(title: "SignOut!",
                               cancelButtonName: "No",
                               message: "Do you want to Signout?",
                               actionButtonName: "Yes, Sign me out") {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension BaseViewController: CellDelegate, SFSafariViewControllerDelegate {
    func didTapSourceButton(with url: String) {
        navigateToSafariVC(with: url)
    }
    
    func navigateToSafariVC(with url: String) {
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true, completion: nil)
        vc.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension BaseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

