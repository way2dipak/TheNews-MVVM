//
//  CategoryCell.swift
//  TheNews
//
//  Created by Dipak Singh on 11/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func toggleSelection(_ toggle: Bool) {
        if toggle {
            vwBackground.backgroundColor = UIColor(named: "DarkPink")
            lblCategory.textColor = .white
        } else {
            vwBackground.backgroundColor = .clear
            lblCategory.textColor = UIColor(named: "DarkPink")
        }
    }

}
