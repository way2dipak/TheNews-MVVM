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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpValue(details: CoronaViewModel) {
        confirmedLabel.text = Global.shared.formatNumber(details.coronaData?.confirmed ?? 0) //"\(details.coronaData?.confirmed ?? 0)"
        criticalLabel.text = Global.shared.formatNumber(details.coronaData?.critical ?? 0)//"\(details.coronaData?.critical ?? 0)"
        recoveredLabel.text = Global.shared.formatNumber(details.coronaData?.recovered ?? 0)//"\(details.coronaData?.recovered ?? 0)"
        deathLabel.text = Global.shared.formatNumber(details.coronaData?.deaths ?? 0)//"\(details.coronaData?.deaths ?? 0)"
    }
    
}
