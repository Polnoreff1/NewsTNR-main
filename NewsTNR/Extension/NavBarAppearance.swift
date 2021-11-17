//
//  NavBarAppearance.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit

extension UINavigationBarAppearance {
    func setDefaultNavBar(color: UIColor = .clear) {
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor = color
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "arrow_left")?.withAlignmentRectInsets(.init(top: 0, left: -6, bottom: 0, right: 0))
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "arrow_left")
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
