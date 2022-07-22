//
//  GlobalCaseTableViewCell.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class GlobalCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblGlobalRate: UILabel!
    @IBOutlet weak var lblTotalRecovered: UILabel!
    @IBOutlet weak var lblCritical: UILabel!
    @IBOutlet weak var lblTotalDeaths: UILabel!
    @IBOutlet weak var lblLastUpdatedAgo: UILabel!
    
    var details: GlobalRate? {
        didSet {
            lblGlobalRate.text = Global.shared.formatNumber(details?.totalConfirmed ?? 0)
            lblTotalRecovered.text = Global.shared.formatNumber((details?.totalConfirmed ?? 0) - (details?.totalDeaths ?? 0))
            lblTotalDeaths.text = Global.shared.formatNumber(details?.totalDeaths ?? 0)
            lblCritical.text = "0"
            lblLastUpdatedAgo.text = details?.returnLastUpdatedOn() ?? ""
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
