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
    private var dataRepo = HeadlinesDataManager()
    
    func fetchTopHeadLines(for pageNo: Int, completion: @escaping((ArticleResponse?) -> Void)) {
        dataRepo.fetchTopHeadlines(for: pageNo, completion: completion)
    }
    
}
