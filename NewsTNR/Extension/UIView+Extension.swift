//
//  UIView+Extension.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow(radius: CGFloat = .zero, xOffset: CGFloat = .zero, yOffset: CGFloat = .zero, shadowOpacity: Float = 0.18, shadowColor: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
    }
}
