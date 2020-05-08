//
//  SearchService.swift
//  TheNews
//
//  Created by DS on 06/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class SearchService: NSObject {
    
    func fetchResults(with search: String, for pageNo: Int, result: @escaping(([ArticleModel], Int)->()), error: @escaping((String)->())) {
        let url = "http://newsapi.org/v2/everything?q=\(search)&page=\(pageNo)&apiKey=acab9e2a8ef7499291cb7f4b99289c91"
        NetworkManager.shared.httpRequestWith(link: url, method: .GET, headers: [:], params: [:], model: DiscoverModel.self, onSuccess: { (response) in
            
            if response.status.lowercased() == "ok" {
                if response.articles.count != 0 {
                    result(response.articles, response.totalResults)
                }
                else {
                    error("")
                }
            }
            else {
                error(response.message)
            }
        }) { (message) in
            error(message)
        }
    }
    
}
