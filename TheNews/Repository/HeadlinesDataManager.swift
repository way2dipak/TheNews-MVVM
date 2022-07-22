//
//  HeadlinesDataManager.swift
//  TheNews
//
//  Created by Dipak Singh on 12/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

class HeadlinesDataManager {
    
    private let network = NetworkManagerClient()
    private let repo = DiscoverDataRepository()
    
    func fetchTopHeadlines(for pageNo: Int,
                           completion: @escaping((ArticleResponse?) -> Void)) {
        let request = URLRepository.headlines(pageNo).dataRequest
        network.httpRequestWith(request) { [weak self] (response: ArticleResponse) in
            guard let _ = self else { return }
            completion(response)
        } failure: { error in
            print("Error: \(error ?? "")")
        }

    }
    
}
