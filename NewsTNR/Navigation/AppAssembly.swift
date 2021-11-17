//
//  AppAssembly.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit

class AppAssembly: NSObject {
    func detailNewsViewController(navigator: Navigator , news: Result) -> UIViewController {
        let presenter = NewsDetailPresenter(navigator: navigator, news: news)
        let viewController = NewsDetailViewController(presenter: presenter)
        return viewController
    }
}
