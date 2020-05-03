//
//  LoaderTableViewCell.swift
//  TheNews
//
//  Created by Nisha Poddar on 03/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class LoaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
