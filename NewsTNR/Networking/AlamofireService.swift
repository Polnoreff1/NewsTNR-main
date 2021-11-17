//
//  AlamofireService.swift
//  NewsTNR
//
//  Created by Andrey Versta on 15.11.2021.
//

import Alamofire

protocol AlamofireNetworkProtocol {
    func getNews(filterType: String, completion: @escaping (News) -> Void)
}

class AlamofireNetwork: AlamofireNetworkProtocol {
    
    func getNews(filterType: String, completion: @escaping (News) -> Void) {
        
        let urlParams = [
            "api-key": "mQJEBFlyWjqfo0ArkXlFsOLtwuShX9EB"
        ]
        
        guard let url = URL(string: APIEndpoint.baseURL + filterType) else { return }
        
        AF.request(url, parameters: urlParams).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let news: News = try decoder.decode(News.self, from: data)
                    completion(news)
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
