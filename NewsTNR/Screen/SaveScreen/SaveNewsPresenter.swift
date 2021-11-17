//
//  ProfilePresenter.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import UIKit
import CoreData

protocol SaveNewsPresenterProtocol {
    var news: [NSManagedObject] { get set }
    
    func showDetailNewsVC(view: UIViewController, news: Result)
}

class SaveNewsPresenter: SaveNewsPresenterProtocol {
    
    var news: [NSManagedObject] = [] {
        didSet {
            view.update(with: news, animated: true)
        }
    }
    
    private let navigator: NavigatorProtocol
    private let networkService: AlamofireNetworkProtocol
    private var view: SaveNewsViewControllerProtocol!
    
    init(navigator: NavigatorProtocol, networkService: AlamofireNetworkProtocol) {
        self.navigator = navigator
        self.networkService = networkService
    }
    
    func set(view: SaveNewsViewControllerProtocol) {
        self.view = view
    }
    
    func showDetailNewsVC(view: UIViewController, news: Result) {
        navigator.navigateToDetailVC(view: view, news: news)
    }

}
