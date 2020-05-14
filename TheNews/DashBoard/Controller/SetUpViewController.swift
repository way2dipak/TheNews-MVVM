//
//  SetUpViewController.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class SetUpViewController: UIViewController {
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCountryList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    
    func displaySpinner(_ success : Bool) {
        if success {
            DispatchQueue.main.async {
                self.spinner.startAnimating()
            }
        }
        else {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.navigateToNextVC()
            }
        }
    }
    
    func navigateToNextVC() {
        let vc = StoryBoardManager.shared.getStoryboard(name: .DashBoard).instantiateViewController(withIdentifier: DashBoardTabController.identifier) as! DashBoardTabController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCountryList() {
        displaySpinner(true)
        SetupService().fetchAllCountryList(result: { [weak self](list) in
            Global.shared.country = list
            self?.displaySpinner(false)
        }) { [weak self](message) in
            self?.displaySpinner(false)
            print("Error: \(message)")
        }
    }


}
