//
//  Extension.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var identifier: String {
        return String(describing: type(of: self))
    }
    
    class var identifier: String {
        return String(describing: self)
    }
}

extension ViewController {
    func displayAlert(title: String, message: String) -> Void {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okButton)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func displayAlertWithAction(title: String, cancelButtonName: String, message: String, actionButtonName: String, action: @escaping (()-> Void)) -> Void {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: cancelButtonName, style: .default, handler: nil)
            let retryButton = UIAlertAction(title: actionButtonName, style: .destructive) { (handler) in
                action()
            }
            alertVC.addAction(okButton)
            alertVC.addAction(retryButton)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    func displayAlertWithRetryAction(title: String, message: String, actionButtonName: String, action: @escaping (()-> Void)) -> Void {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let retryButton = UIAlertAction(title: actionButtonName, style: .destructive) { (handler) in
                action()
            }
            alertVC.addAction(retryButton)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func displayAlertWithTextField(title: String, message: String, actionButtonName: String, action: @escaping ((String)-> Void)) -> Void {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addTextField { (textField) in
                textField.placeholder = "Enter City Name"
            }
            let addButton = UIAlertAction(title: actionButtonName, style: .default) { (handler) in
                let textField = alertVC.textFields![0]
                action(textField.text ?? "")
            }
            alertVC.addAction(addButton)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
