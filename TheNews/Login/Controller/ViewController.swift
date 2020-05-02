//
//  ViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import GoogleSignIn



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }


}


