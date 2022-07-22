//
//  ChooseCountryTableViewCell.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class ChooseCountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var lastUpdateLabel: UILabel! {
        didSet {
            lastUpdateLabel.isHidden = true
        }
    }
    
    var handler: (()->())?
    
    var details: Country? {
        didSet {
            selectCountryButton.setTitle(details?.country ?? "", for: .normal)
            //lastUpdateLabel.text = details?.returnLastUpdatedOn() ?? ""//dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onTappedSelectCountryButton(_ sender: UIButton) {
        handler?()
    }
    
}
