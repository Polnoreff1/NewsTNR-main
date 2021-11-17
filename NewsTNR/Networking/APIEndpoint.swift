//
//  APIEndpoint.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import Foundation

enum APIEndpoint {

    static var baseURL = "https://api.nytimes.com/svc/mostpopular/v2"

    case getEmailedNews(Int)
    case getViewedNews(Int)
    case getSharedNews(Int)

    var stringValue: String {
        switch self {
        
        case .getEmailedNews(let period): return "/emailed/\(period).json"
        case .getViewedNews(let period): return "/viewed/\(period).json"
        case .getSharedNews(let period): return "/shared/\(period).json"
        }
    }
}
