//
//  NewsCell.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit
import Kingfisher

// MARK: - NewsCell
class NewsCell: UICollectionViewCell, CellIdentifiable {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var newsImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var shadowView: UIView!
    @IBOutlet weak private var cornerView: UIView!
    
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Methods
    @discardableResult
    func config(with model: Result) -> NewsCell {
        model.media?.forEach { media in
            media.mediametadata?.forEach {
                guard let image = $0.url, let url = URL(string: image) else { return }
                DispatchQueue.main.async {
                    self.newsImageView.kf.setImage(with: url)
                }
            }
        }
        titleLabel.text = model.title
        return self
    }
    
    private func setupUI() {
       
        newsImageView.layer.cornerRadius = 15
        cornerView.layer.cornerRadius = 15
        cornerView.clipsToBounds = true
        clipsToBounds = false
        shadowView.dropShadow(radius: 3, xOffset: 0, yOffset: 1, shadowOpacity: 0.3, shadowColor: .black)
    }
}
