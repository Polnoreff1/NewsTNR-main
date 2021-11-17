//
//  SaveNewsCell.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit

// MARK: - SaveNewsCell
class SaveNewsCell: UICollectionViewCell, CellIdentifiable {
    
    @IBOutlet weak private var newsImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var shadowView: UIView!
    @IBOutlet weak private var cornerView: UIView!
    @IBOutlet weak private var shadowCloseView: UIView!
    @IBOutlet weak var closeImageView: UIImageView!
    
    var completion: Closure?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @discardableResult
    func config(with model: SaveNews?) -> SaveNewsCell {
        guard let model = model else { return self }
        newsImageView.image = model.image
        titleLabel.text = model.title
        
        return self
    }
}

// MARK: - Private Extension
private extension SaveNewsCell {
    func setupUI() {
        clipsToBounds = false
        setupCloseView()
        setupImageView()
    }
    
    func setupCloseView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapToClose))
        closeImageView.addGestureRecognizer(gesture)
        closeImageView.isUserInteractionEnabled = true
        closeImageView.clipsToBounds = true
        closeImageView.image?.withRenderingMode(.alwaysTemplate)
        closeImageView.image?.withTintColor(.yellow)
        shadowCloseView.backgroundColor = .clear
    }
    
    func setupImageView() {
        newsImageView.layer.cornerRadius = 15
        cornerView.layer.cornerRadius = 15
        cornerView.clipsToBounds = true
        shadowView.dropShadow(radius: 3, xOffset: 0, yOffset: 1, shadowOpacity: 0.3, shadowColor: .black)
    }
    
    @objc
    func tapToClose() {
        completion?()
    }
}
