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

//Corner Radius and Shadow
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}


extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

//Fade IN and OUT
extension UITableView {
    func hideTableView(_ value: Bool) {
        DispatchQueue.main.async {
            if value {
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 0
                }
            }
            else {
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
            }
        }
    }
}

extension UIView {
    func hideView(_ value: Bool) {
        DispatchQueue.main.async {
            if value {
                //UIView.animate(withDuration: 0.3) {
                self.alpha = 0
                //}
            }
            else {
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1
                }
            }
        }
    }
}

//Alert
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
