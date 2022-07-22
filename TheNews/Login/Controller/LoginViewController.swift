//
//  LoginViewController.swift
//  TheNews
//
//  Created by DS on 03/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var lblDescription: UILabel! {
        didSet {
            lblDescription.setLineHeight(lineHeight: 5)
        }
    }
    @IBOutlet weak var lblSiriSuggestion: UILabel! {
        didSet {
            lblSiriSuggestion.setLineHeight(lineHeight: 5, alignment: .center)
        }
    }
    @IBOutlet weak var vwStack: UIStackView! {
        didSet {
            vwStack.alpha = 0.1
            self.vwStack.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        }
    }
    @IBOutlet weak var vwBottom: UIView! {
        didSet {
            vwBottom.alpha = 0
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnContinueBottomConstraint: NSLayoutConstraint!
    
    private var vwModel = LoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playStackAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func playStackAnimation() {
        UIView.animate(withDuration: 0.8, animations: {
            self.vwStack.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.vwStack.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                if !Reachability.isConnectedToNetwork() {
                    self.navigateToNextVC()
                    return
                }
                self.restorePreviousSignIn()
            })
        }
    }
    
    func playBtnContinueAnimation(duration: TimeInterval = 0.5) {
        spinner.alpha = 0
        vwBottom.transform = CGAffineTransform(translationX: 0, y: 100)
        UIView.animate(withDuration: duration) {
            self.vwStack.transform = CGAffineTransform(translationX: 0, y: -100)
            self.vwBottom.transform = CGAffineTransform(translationX: 0, y: 0)
            self.vwBottom.alpha = 1
        }
    }
    
    func restorePreviousSignIn() {
        vwModel.restorePreviousSignin { [weak self] apiKey in
            if apiKey != "" {
                Global.shared.apikey = apiKey
                self?.navigateToNextVC()
            } else {
                self?.playBtnContinueAnimation()
            }
        }
    }
    
    @IBAction func onTapSignInButton(_ sender: Any) {
        vwBottom.alpha = 0
        spinner.alpha = 1
        vwModel.performSign(vc: self) { [weak self] in
            self?.spinner.alpha = 0
            if Global.shared.apikey != "" {
                self?.vwModel.saveApiKey(apiKey: Global.shared.apikey)
                self?.navigateToNextVC()
            } else {
                self?.playBtnContinueAnimation(duration: 1)
            }
        }
    }
}

extension LoginViewController {
    func navigateToNextVC() {
        let vc = StoryBoardManager.shared.getStoryboard(name: .DashBoard).instantiateViewController(withIdentifier: DashBoardTabController.identifier) as! DashBoardTabController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
