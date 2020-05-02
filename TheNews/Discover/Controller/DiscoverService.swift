//
//  DiscoverService.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

class DiscoverService {
    
    func fetchDiscover(for pageNo: String, result: @escaping((DiscoverViewModel)->()), error: @escaping((String)->())) {
        let url = "http://newsapi.org/v2/everything?q=news&page=1&apiKey="
        NetworkManager.shared.httpRequestWith(link: url, method: .GET, headers: [:], params: [:], model: DiscoverModel.self, onSuccess: { [weak self](response) in
            <#code#>
        }) { (error) in
            <#code#>
        }
    }
    
}
