//
//  DiscoverViewModel.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation


struct DiscoverViewModel {
    let id: String
    let name: String
    let author, title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    
    // Dependency Injection (DI)
    init(articles: ArticleModel) {
        self.id = articles.source.id
        self.name = articles.source.name
        self.author = articles.author
        self.title = articles.title
        self.articleDescription = articles.articleDescription
        self.url = articles.url
        self.urlToImage = articles.urlToImage
        self.publishedAt = articles.publishedAt
        self.content = articles.content
    }
}
