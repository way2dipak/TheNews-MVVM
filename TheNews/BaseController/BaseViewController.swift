//
//  BaseViewController.swift
//  TheNews
//
//  Created by DS on 03/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = getRightBarButton()
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
    
    func layoutCustomizationToNavBar() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        self.navigationController?.navigationBar.barTintColor = .white
    }
 
    
    @objc func onTapProfileButton() {
        
    }
}
