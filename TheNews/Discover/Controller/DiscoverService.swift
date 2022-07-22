//
//  DiscoverService.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

class DiscoverService {
    private var dataRepo = DiscoverDataManager()
    
    func fetchAllDiscoverList(with query: String,
                              for pageNo: Int,
                              isPaginationRequired: Bool = false,
                              clearList: Bool = false,
                              completion: @escaping((ArticleResponse?) -> Void)) {
        dataRepo.fetchDiscoverList(with: query,
                                   isPaginationRequired: isPaginationRequired,
                                   clearList: clearList,
                                   for: pageNo,
                                   completion: completion)
    }
    
}
