//
//  GenerateApiKey.swift
//  TheNews
//
//  Created by Dipak Singh on 14/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import UIKit
import WebKit

class AccountVC: BaseViewController {
    
    enum OperationType {
        case account
        case login
        case others
    }
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnClose: UIButton!
    
    var isBackBtnTapped = false
    var dismissHandler: (() -> ())?
    
    var type: OperationType = .account
    
    private var vwModel = LoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnClose.isHidden = false
        switch type {
        case .account:
            btnClose.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        case .others:
            btnClose.isHidden = true
        case .login:
            btnClose.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
            
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isBackBtnTapped {
            dismissHandler?()
        }
    }
    
    func loadURL() {
        let url = URL(string: "https://newsapi.org/login")!
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
    }
    
    func addLoginScript() {
        let items = "document.getElementsByClassName('flex justify-between')[0].style.display = 'none';"
        webView.evaluateJavaScript(items) { [weak self] results, error in
            guard let _ = self else { return }
        }
    }
    
    func addScript() {
        let items = "document.getElementsByClassName('flex justify-between')[0].style.display = 'none';" + "document.getElementsByClassName('tc')[0].style.display = 'none';" + "document.getElementsByClassName('flex justify-between')[0].style.display = 'none';"
        webView.evaluateJavaScript(items) { [weak self] results, error in
            guard let _ = self else { return }
        }
    }
    
    func grabApiKey() {
        let items = "document.getElementsByClassName('flex justify-between')[0].style.display = 'none';" + "document.getElementsByTagName('code')[0].innerHTML;"
        webView.evaluateJavaScript(items) { [weak self] results, error in
            guard let _ = self else { return }
            let apiKey = results as? String ?? ""
            if apiKey != "" && apiKey.lowercased() != "none" {
                Global.shared.apikey = apiKey
            }
        }
    }
    
    func grabApiKeyFromMyAccount() {
        let items = "document.getElementsByClassName('flex justify-between')[0].style.display = 'none';" + "const buttons = document.getElementsByClassName('btn');for(const btn of buttons) { btn.style.display = 'none'; };" + "const myLabels = document.getElementsByTagName('label');for(const lbl of myLabels) { if (lbl.innerHTML == 'Password') { lbl.style.display = 'none';} };"// + "document.getElementsByTagName('h1')[0].style.display = 'none';"
        webView.evaluateJavaScript(items) { [weak self] results, error in
            guard let _ = self else { return }
        }
        let grapApiScript = "document.getElementById('ApiKey').value;"
        webView.evaluateJavaScript(grapApiScript) { [weak self] results, error in
            guard let _ = self else { return }
            let apiKey = results as? String ?? ""
            if apiKey != "" && apiKey.lowercased() != "none" {
                Global.shared.apikey = apiKey
            }
        }
    }
    
    func removeCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        vwModel.clearApi()
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        if type == .login {
            isBackBtnTapped = true
            self.dismiss(animated: true) { [weak self] in
                self?.dismissHandler?()
            }
        } else {
            removeCookies()
            AppDelegate.shared.rootNavigationController?.popToRootViewController(animated: true)
        }
    }
}

extension AccountVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner.startAnimating()
        webView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        webView.isHidden = false
        if let url = webView.url?.absoluteString {
            if url == "https://newsapi.org/login" {
                addLoginScript()
            } else if url == "https://newsapi.org/register/success" {
                grabApiKey()
            } else if url == "https://newsapi.org/account" {
                grabApiKeyFromMyAccount()
            } else {
                addScript()
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        self.displayAlertWithAction(title: "!!Alert!!", cancelButtonName: "", message: error.localizedDescription, actionButtonName: "Dismiss") { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
}
