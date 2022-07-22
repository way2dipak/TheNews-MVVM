//
//  URLRepository.swift
//  TheNews
//
//  Created by Dipak Singh on 27/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

enum URLRepository {
    case discover(String, Int)
    case headlines(Int)
    case corona
    
    var dataRequest: APIRequest {
        switch self {
        case .discover(let query, let pageNo):
            return APIRequest(path: "everything?q=\(query)&page=\(pageNo)&from=\(Date().get1monthDifferenceDate().1)&language=en&sortBy=publishedAt", method: .GET)
        case .headlines(let pageNo):
            return APIRequest(path: "top-headlines?category=business&language=en&page=\(pageNo)&sortBy=publishedAt", method: .GET)
        case .corona:
            return APIRequest(baseURL: "https://api.covid19api.com/", path: "summary", method: .GET)
        }
    }
}
