//
//  HeadLineViewModel.swift
//  TheNews
//
//  Created by Dipak Singh on 12/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

class HeadLineViewModel {
    var articleList: [ArticleModel] = []
    var totalResults = 0
    var offset = 1
    var isLoading = true
    var isPaginationNeeded: Bool {
        get {
            if totalResults != 0 {
                return articleList.count < totalResults
            }
            return true
        }
    }
    
    var refreshUI: (() -> ())?
    var errorUI: (() -> ())?
    
    private let service = HeadLinesService()
    
    func getNumberOfSection() -> Int {
        if isPaginationNeeded {
            return 2
        } else {
            return 1
        }
    }
    
    func getNumberOfRowsIn(section: Int) -> Int {
        if section == 0 {
            if articleList.count == 0 {
                return 10
            }
            return articleList.count
        } else {
            return 1
        }
    }
    
    func fetchTopHeadlines(clearArray: Bool = false) {
        if !isPaginationNeeded { return }
        self.isLoading = true
        if clearArray {
            articleList.removeAll()
            refreshUI?()
        }
        service.fetchTopHeadLines(for: offset) { [weak self] headlines in
            guard let self = self else { return }
            self.totalResults = headlines?.totalResults ?? 0
            self.articleList += headlines?.articles ?? []
            self.offset += 1
            self.refreshUI?()
        }
    }
    
}
