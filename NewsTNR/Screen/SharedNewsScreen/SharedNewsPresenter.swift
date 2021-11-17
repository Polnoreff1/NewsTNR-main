//
//  SharedNewsPresenter.swift
//  NewsTNR
//
//  Created by Andrey Versta on 17.11.2021.
//

import UIKit

protocol SharedNewsPresenterProtocol {
    var news: [Result] { get }
    
    func getNews(period: Int)
    func showDetailNewsVC(view: UIViewController, news: Result)
}

class SharedNewsPresenter: SharedNewsPresenterProtocol {
    // MARK: - Properties
    var news: [Result] = [] {
        didSet {
            view.update(with: news, animated: true)
        }
    }
    
    private let navigator: NavigatorProtocol
    private let networkService: AlamofireNetworkProtocol
    private var view: SharedNewsViewControllerProtocol!
    
    // MARK: - Init
    init(navigator: NavigatorProtocol, networkService: AlamofireNetworkProtocol) {
        self.navigator = navigator
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func set(view: SharedNewsViewControllerProtocol) {
        self.view = view
    }
    
    func getNews(period: Int) {
        networkService.getNews(filterType: APIEndpoint.getSharedNews(period).stringValue) { model in
            guard let news = model.results else { return }
            self.news = news
        }
    }
    
    func showDetailNewsVC(view: UIViewController, news: Result) {
        navigator.navigateToDetailVC(view: view, news: news)
    }
}
