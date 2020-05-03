//
//  ArticlesTableViewCell.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import Kingfisher

protocol CellDelegate {
    func didTapSourceButton()
}

class ArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleCoverImageView: UIImageView! {
        didSet{
            self.articleCoverImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.articleCoverImageView.cornerRadius = 10
        }
    }
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleContentTextView: UITextView!
    @IBOutlet weak var articlesPostedOnLabel: UILabel!
    @IBOutlet weak var sourceButton: UIButton!
    
    var sourceUrl = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func setUpValues(details: DiscoverViewModel) {
        articleCoverImageView.kf.indicatorType = .activity
        articleCoverImageView.kf.indicator?.view.tintColor = .white
        articleCoverImageView.kf.setImage(with: URL(string: details.urlToImage), placeholder: #imageLiteral(resourceName: "Placeholder"), options: [.transition(.fade(0.3))], progressBlock: nil) { [weak self](result) in
            if let strongSelf = self {
                switch result {
                case .success(let response) :
                    strongSelf.articleCoverImageView.image = response.image
                case .failure(let error):
                    print("ImageFailedToLoad: \(error.errorDescription ?? "Failed to get image")")
                }
            }
        }
        articleTitleLabel.text = details.title
        articleContentTextView.text = details.articleDescription
        articlesPostedOnLabel.text = details.publishedAt
        sourceButton.setTitle("Source: \(details.name)", for: .normal)
        sourceUrl = details.url
    }
    
    @IBAction func onTapVisitSourceButton(_ sender: UIButton) {
        
    }
    
}
