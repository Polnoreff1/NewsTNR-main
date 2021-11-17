//
//  UIViewController+Child.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit

// MARK: - Child management
extension UIViewController {

    func addChild(_ child: UIViewController, toContainer container: UIView) {

        addChild(child)

        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        child.view.frame = container.bounds
        container.addSubview(child.view)

        child.didMove(toParent: self)
    }

    func removeChild(_ child: UIViewController) {

        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
