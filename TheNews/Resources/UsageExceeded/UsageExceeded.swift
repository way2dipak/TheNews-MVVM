//
//  UsageExceeded.swift
//  TheNews
//
//  Created by Dipak Singh on 18/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import UIKit

class UsageExceeded: UIView {
    
    @IBOutlet var contentView: UIView!
    
    class func instanceFromNib() -> UsageExceeded {
        return UINib(nibName: "UsageExceeded", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UsageExceeded
    }
    
    var btnHandler: (() -> ())?
    
    func hideTheView() {
        self.removeAllSubviews()
        self.layoutIfNeeded()
        self.removeFromSuperview()
    }
    
    @IBAction func onTapBtnAccount(_ sender: UIButton) {
        //hideTheView()
        btnHandler?()
    }
    
    
}
