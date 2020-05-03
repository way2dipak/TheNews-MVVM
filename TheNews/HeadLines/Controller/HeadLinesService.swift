//
//  HeadLinesService.swift
//  TheNews
//
//  Created by DS on 03/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class HeadLinesService: NSObject {
    
    func fetchTopHeadLines(for pageNo: Int, result: @escaping(([ArticleModel])->()), error: @escaping((String)->())) {
        let url = "http://newsapi.org/v2/top-headlines?country=in&page=\(pageNo)&apiKey=acab9e2a8ef7499291cb7f4b99289c91"
        NetworkManager.shared.httpRequestWith(link: url, method: .GET, headers: [:], params: [:], model: DiscoverModel.self, onSuccess: { (response) in
            
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
