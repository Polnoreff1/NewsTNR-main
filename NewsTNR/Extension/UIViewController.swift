//
//  UIViewController.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import Foundation
import UIKit

enum BackButtonType {
    case back
    case cancel
}

private var actionKey: Void?

extension UIViewController {
    private var _action: () -> Void {
        get {
            return objc_getAssociatedObject(self, &actionKey) as! () -> Void
        }
        set {
            objc_setAssociatedObject(self, &actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addCustomizeNavigationBackButton(type: BackButtonType, completion: @escaping Closure) {
        var backButton = UIBarButtonItem()
        _action = completion
        switch type {
        case .cancel:
            let text = "Cancel"
            backButton = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(pressed))
        case .back:
            guard let image = UIImage(named: "ico_backButton")?.withRenderingMode(.alwaysTemplate) else { return }
            image.withTintColor(.black)
            backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(pressed))
        }
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc
    private func pressed(sender: UIBarButtonItem) {
        _action()
    }
}
