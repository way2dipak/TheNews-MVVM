//
//  Extension.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

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
    
    func removeAllSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
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

extension UIImageView {
    func loadImage(with url: String, placeholder: UIImage? = #imageLiteral(resourceName: "Placeholder"), completion: SDExternalCompletionBlock?) {
        //self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //self.sd_imageTransition = .fade(duration: 0.3)
        self.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: [], completed: completion)
    }
}

extension UIButton {
    func loadImage(with url: String, placeholder: UIImage? = #imageLiteral(resourceName: "Placeholder"), completion: SDExternalCompletionBlock?) {
        self.imageView?.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: [], completed: completion)
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
    
    func adding(months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months
        
        return calendar.date(byAdding: components, to: self)
    }
    
    func get1monthDifferenceDate() -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var lastMonthDate = ""
        if let lastMonth = Date().adding(months: -1) {
            lastMonthDate = dateFormatter.string(from: lastMonth)
        }
        let currentMonthDate = dateFormatter.string(from: Date())
        return (currentMonthDate, lastMonthDate)
    }
    
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    var startOfDay: Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    func compareSame(date:Date) -> Bool {
        let order = Calendar.current.compare(self, to: date, toGranularity: .day)
        return order == .orderedSame
    }
    
    func compareAssending(date:Date) -> Bool {
        let order = Calendar.current.compare(self, to: date, toGranularity: .day)
        return order == .orderedAscending
    }
    
    func toString(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'")-> Date?{ //yyyy-MM-ddTHH:mm:ssZ //2021-04-23T08:29:00Z
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func widthOfString(usingFont font: UIFont? = UIFont(name: "Roboto-Bold", size: 15)) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font!]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont? = UIFont(name: "Roboto-Bold", size: 15)) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font!]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont? = UIFont(name: "Roboto-Bold", size: 15)) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font!]
        return self.size(withAttributes: fontAttributes)
    }
    
}

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat, alignment: NSTextAlignment = .left) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            style.alignment = alignment
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data,
                                                                    options: .allowFragments) as? [String: Any] else {
                return [:]
            }
            return dictionary
        } catch {
            return [:]
        }
    }
    
    /// Converting object to postable JSON String
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) -> String {
        let data = try? encoder.encode(self)
        if let newData = data {
            let result = String(decoding: newData, as: UTF8.self)
            return result
        } else {
            return ""
        }
    }
}

extension Data {
    func decode<T: Codable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
