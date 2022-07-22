//
//  DiscoverModel.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

struct ArticleResponse: Codable {
    let status: String
    let message: String
    let totalResults: Int
    let articles: [ArticleModel]
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case message = "message"
        case articles = "articles"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decodeIfPresent(String.self, forKey: .status) ?? "error"
        self.message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        self.articles = try values.decodeIfPresent([ArticleModel].self, forKey: .articles) ?? [ArticleModel]()
    }
    
    init(from item: CDHome?) {
        self.status = "OK"
        self.message = ""
        self.totalResults = Int(item?.totalResults ?? 0)
        self.articles = item?.getArticles() ?? []
    }
}

struct ArticleModel: Codable {
    let source: SourceModel?
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
    
    func convertTimeStampToDate(date: String? = nil)-> String {
        return self.publishedAt.toDate()?.timeAgoSinceDate() ?? ""
    }
    
    func sourceName() -> String {
        return self.source?.name ?? ""
    }
}

struct SourceModel: Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}



