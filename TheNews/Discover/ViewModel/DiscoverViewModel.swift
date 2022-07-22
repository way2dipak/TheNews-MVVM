//
//  DiscoverViewModel.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation


class DiscoverViewModel {
    var categoryList = ["general", "gadgets", "cricket", "business", "gaming", "movie", "health", "space", "science", "bitCoin", "technology"]
    var selectedCategory = "general"
    
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
    
    private let service = DiscoverService()
    
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
    
    func fetchDiscoverList(clearArray: Bool = false) {
        if !isPaginationNeeded { return }
        self.isLoading = true
        if clearArray {
            articleList.removeAll()
            refreshUI?()
        }
        service.fetchAllDiscoverList(with: selectedCategory,
                                     for: offset,
                                     isPaginationRequired: isPaginationNeeded,
                                     clearList: clearArray) { [weak self] discover in
            guard let self = self else { return }
            self.totalResults = Int(discover?.totalResults ?? 0)
            self.articleList += discover?.articles ?? []
            self.offset += 1
            self.refreshUI?()
        }
    }
    
    func toggleCategorySelection(for index: Int) -> Bool {
        return categoryList[index].lowercased() == selectedCategory.lowercased()
    }
    
    func isSameCategorySelected(index: Int) -> Bool {
        if selectedCategory.lowercased() == categoryList[index].lowercased() {
            return true
        } else {
            totalResults = 0
            offset = 1
            return false
        }
    }
}
