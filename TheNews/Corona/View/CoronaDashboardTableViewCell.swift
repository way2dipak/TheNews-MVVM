//
//  CoronaDashboardTableViewCell.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class CoronaDashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var criticalLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var newConfirmedView: UIView! {
        didSet {
            newConfirmedView.isHidden = true
        }
    }
    @IBOutlet weak var lblNewConfirmed: UILabel!
    @IBOutlet weak var newDeceasedView: UIView! {
        didSet {
            newDeceasedView.isHidden = true
        }
    }
    @IBOutlet weak var lblnewDeath: UILabel!
    
    var details: Country? {
        didSet {
            confirmedLabel.text = Global.shared.formatNumber(details?.totalConfirmed ?? 0)
            criticalLabel.text = "0"
            recoveredLabel.text = Global.shared.formatNumber((details?.totalConfirmed ?? 0) - (details?.totalDeaths ?? 0))
            deathLabel.text = Global.shared.formatNumber(details?.totalDeaths ?? 0)
            if details?.newConfirmed ?? 0 != 0 {
                newConfirmedView.isHidden = false
                lblNewConfirmed.text = "+" + Global.shared.formatNumber(details?.newConfirmed ?? 0)
            } else {
                newConfirmedView.isHidden = true
            }
            if details?.newDeaths ?? 0 != 0 {
                newDeceasedView.isHidden = false
                lblnewDeath.text = "+" + Global.shared.formatNumber(details?.newDeaths ?? 0)
            } else {
                newDeceasedView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
