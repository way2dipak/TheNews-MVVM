//
//  SourceWebViewController.swift
//  TheNews
//
//  Created by DS on 03/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import WebKit

class SourceWebViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            self.webView.navigationDelegate = self
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var sourcelUrl = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl(with: sourcelUrl)
    }

    func loadUrl(with url: String) {
        let request = URL(string: url)!
        webView.load(URLRequest(url: request))
    }
}

extension SourceWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        self.displayAlertWithAction(title: "Error", cancelButtonName: "Ok", message: error.localizedDescription, actionButtonName: "Retry") {
            self.loadUrl(with: self.sourcelUrl)
        }
    }
}
