//
//  NewsDetailPresenter.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import Foundation

// MARK: - NewsDetailPresenterProtocol
protocol NewsDetailPresenterProtocol {
    var news: Result { get }
}
 
// MARK: - NewsDetailPresenter
class NewsDetailPresenter: NewsDetailPresenterProtocol {
    
    // MARK: - Properties
    var news: Result
        
    private let navigator: NavigatorProtocol
    
    // MARK: - Init
    init(navigator: NavigatorProtocol, news: Result) {
        self.navigator = navigator
        self.news = news
    }
}
