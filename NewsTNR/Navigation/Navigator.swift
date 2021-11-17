//
//  Navigator.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit

protocol NavigatorProtocol {
    func navigateToDetailVC(view: UIViewController, news: Result)
}

class Navigator: NavigatorProtocol {

    var appAssembly: AppAssembly = AppAssembly()
    
    func navigateToDetailVC(view: UIViewController, news: Result) {
        let vc = appAssembly.detailNewsViewController(navigator: self, news: news)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}
