//
//  ArticlesTableViewCell.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import SkeletonView

protocol CellDelegate {
    func didTapSourceButton(with url: String)
}

class ArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleCoverImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel! {
        didSet {
            self.articleTitleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet weak var articleContentTextView: UILabel! {
        didSet {
            self.articleContentTextView.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet weak var articlesPostedOnLabel: UILabel! {
        didSet {
            self.articlesPostedOnLabel.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var imgVwHeightConstraint: NSLayoutConstraint!
    
    var sourceUrl = ""
    var cellDelegate: CellDelegate?
    var layoutHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hideSkeleton(false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleCoverImageView.image = nil
    }
    
    func hideSkeleton(_ toggle: Bool = true) {
        if !toggle {
            articleCoverImageView.showAnimatedSkeleton()
            articleTitleLabel.showAnimatedSkeleton()
            articleContentTextView.showAnimatedSkeleton()
            articlesPostedOnLabel.showAnimatedSkeleton()
            sourceButton.showAnimatedSkeleton()
        } else {
            articleCoverImageView.hideSkeleton()
            articleTitleLabel.hideSkeleton()
            articleContentTextView.hideSkeleton()
            articlesPostedOnLabel.hideSkeleton()
            sourceButton.hideSkeleton()
        }
    }
    
    var details: ArticleModel? {
        didSet {
            articleCoverImageView.loadImage(with: details?.urlToImage ?? "") { [weak self] downloadedImage, err, _, _ in
                guard let self = self else { return }
                if let img = downloadedImage {
                    self.dynamicImageHeight(image: img)
                }
            }
            articleTitleLabel.text = details?.title ?? ""
            articleTitleLabel.setLineHeight(lineHeight: 2)
            articleContentTextView.text = details?.articleDescription ?? ""
            articleContentTextView.setLineHeight(lineHeight: 5)
            articlesPostedOnLabel.text = details?.convertTimeStampToDate() ?? ""
            sourceButton.setTitle("Source: \(details?.sourceName() ?? "")", for: .normal)
            sourceUrl = details?.url ?? ""
        }
    }
    
    @IBAction func onTapVisitSourceButton(_ sender: UIButton) {
        cellDelegate?.didTapSourceButton(with: self.sourceUrl)
    }
    
    func dynamicImageHeight(image: UIImage) {
        let ratio = image.size.width / image.size.height
        let newHeight = articleCoverImageView.frame.width / ratio
        imgVwHeightConstraint.constant = newHeight
        articleCoverImageView.image = image
        layoutHandler?()
    }
    
}
