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
                //UIView.animate(withDuration: 0.0) {
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

extension BaseViewController {
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
            let okButton = UIAlertAction(title: cancelButtonName, style: .default) {
                (handler) in
                self.navigationController?.popViewController(animated: true)
            }
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


extension Date {
    func timeAgoSinceDate() -> String {
        // From Time
        let fromDate = self
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "mins ago"
        }
        
        // Second
        if let interval = Calendar.current.dateComponents([.second], from: fromDate, to: toDate).second, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "second ago" : "\(interval)" + " " + "seconds ago"
        }
        return "NA"
    }
}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'")-> Date?{ //yyyy-MM-ddTHH:mm:ssZ
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

protocol ObjectSavable {
    func saveObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

// Save file in UserDefaults
extension UserDefaults: ObjectSavable {
    func saveObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
