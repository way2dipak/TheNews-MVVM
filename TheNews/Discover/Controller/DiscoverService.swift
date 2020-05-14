//
//  DiscoverService.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

class DiscoverService {
    
    var discover: [String] = ["global", "event", "games", "corona", "technology", "science", "aliens", "facts", "news"]
    
    func fetchDiscover(for pageNo: Int, result: @escaping(([ArticleModel])->()), error: @escaping((String)->())) {
        let randomIndex = Int.random(in: 0..<discover.count)
        let url = "http://newsapi.org/v2/everything?q=\(discover[randomIndex])&page=\(pageNo)&apiKey=acab9e2a8ef7499291cb7f4b99289c91"
        NetworkManager.shared.httpRequestWith(link: url, method: .GET, headers: [:], params: [:], onSuccess: { (response: DiscoverModel) in
            
            if response.status.lowercased() == "ok" {
                result(response.articles)
            }
            else {
                error(response.message)
            }
        }) { (message) in
            error(message)
        }
    }
    
}
