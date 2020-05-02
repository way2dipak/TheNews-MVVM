//
//  DiscoverModel.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

struct DiscoverModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleModel]
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResult"
        case articles = "articles"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decodeIfPresent(String.self, forKey: .status) ?? "error"
        self.totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        self.articles = try values.decodeIfPresent([ArticleModel].self, forKey: .status) ?? [ArticleModel]()
    }
    
}

struct ArticleModel: Codable {
    let source: SourceModel
    let author, title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.source = try values.decodeIfPresent(SourceModel.self, forKey: .source) ?? SourceModel(from: decoder)
        self.author = try values.decodeIfPresent(String.self, forKey: .author) ?? ""
        self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.articleDescription = try values.decodeIfPresent(String.self, forKey: .articleDescription) ?? ""
        self.url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage) ?? ""
        self.publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
        self.content = try values.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
}

struct SourceModel: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
