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

//Button Circular Image
extension UIImage {
    
    func circularImage(withSize size: CGSize?) -> UIImage? {
        let newSize = size ?? self.size

        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()

        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)

        (context!).setBlendMode(.copy)
        (context!).setFillColor(UIColor.clear.cgColor)

        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()

        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        return result
    }


  func crop(to:CGSize) -> UIImage {
    guard let cgimage = self.cgImage else { return self }

    let contextImage: UIImage = UIImage(cgImage: cgimage)

    let contextSize: CGSize = contextImage.size

    //Set to square
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    let cropAspect: CGFloat = to.width / to.height

    var cropWidth: CGFloat = to.width
    var cropHeight: CGFloat = to.height

    if to.width > to.height { //Landscape
        cropWidth = contextSize.width
        cropHeight = contextSize.width / cropAspect
        posY = (contextSize.height - cropHeight) / 2
    } else if to.width < to.height { //Portrait
        cropHeight = contextSize.height
        cropWidth = contextSize.height * cropAspect
        posX = 0
    } else { //Square
        if contextSize.width >= contextSize.height { //Square on landscape (or square)
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        }else{ //Square on portrait
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        }
    }

    let rect: CGRect = CGRect(x : posX, y : posY, width : cropWidth, height : cropHeight)

    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!

    // Create a new image based on the imageRef and rotate back to the original orientation
    let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

    cropped.draw(in: CGRect(x : 0, y : 0, width : to.width, height : to.height))

    return cropped
  }
}
