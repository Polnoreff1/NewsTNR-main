//
//  MainViewPresenter.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import Foundation
import UIKit

// MARK: - NewsPresenterProtocol
protocol NewsPresenterProtocol {
    var news: [Result] { get }
    
    func getNews(period: Int)
    func showDetailNewsVC(view: UIViewController, news: Result)
}

// MARK: - NewsPresenter
class NewsPresenter: NewsPresenterProtocol {
    
    // MARK: - Properties
    var news: [Result] = [] {
        didSet {
            view.update(with: news, animated: true)
        }
    }
    
    private let navigator: NavigatorProtocol
    private let networkService: AlamofireNetworkProtocol
    private var view: NewsViewControllerProtocol!
    
    // MARK: - Init
    init(navigator: NavigatorProtocol, networkService: AlamofireNetworkProtocol) {
        self.navigator = navigator
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func set(view: NewsViewControllerProtocol) {
        self.view = view
    }
    
    func getNews(period: Int) {
        networkService.getNews(filterType: APIEndpoint.getEmailedNews(period).stringValue) { model in
            guard let news = model.results else { return }
            self.news = news
        }
    }
    
    func showDetailNewsVC(view: UIViewController, news: Result) {
        navigator.navigateToDetailVC(view: view, news: news)
    }
}
