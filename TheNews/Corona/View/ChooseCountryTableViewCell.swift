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
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    var handler: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpValue(details: CoronaViewModel) {
        selectCountryButton.setTitle(details.country.capitalized, for: .normal)
        lastUpdateLabel.text = "Last updated"
    }
    
    @IBAction func onTappedSelectCountryButton(_ sender: UIButton) {
        handler?()
    }
    
}
