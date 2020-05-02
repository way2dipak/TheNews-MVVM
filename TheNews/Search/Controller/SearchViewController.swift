//
//  SearchViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: nil)
//        if let image = Global.shared.userObj?.image {
//            var profileImage : UIImageView?
//            profileImage?.kf.setImage(with: URL(string: image), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil) { [weak self](result) in
//                if let strongSelf = self {
//                    switch result {
//                    case .success(let response) :
//                        button.image = response.image
//                    case .failure(let error):
//                        print("ImageFailedToLoad: \(String(describing: error.errorDescription))")
//                    }
//                }
//            }
//        }
    }
}
