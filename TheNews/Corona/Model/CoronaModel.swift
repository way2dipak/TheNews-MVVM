//
//  CoronaModel.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

// MARK: - CoronaResponse
struct CoronaResponse: Codable {
    let id, message: String?
    let global: GlobalRate?
    let countries: [Country]?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case message = "Message"
        case global = "Global"
        case countries = "Countries"
        case date = "Date"
    }
}

// MARK: - Country
struct Country: Codable {
    let id, country, countryCode, slug: String?
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int?
    let newRecovered, totalRecovered: Int?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
    
    func returnLastUpdatedOn() -> String {
        let updatedAgo = date?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")?.timeAgoSinceDate()
        return "Last updated \(updatedAgo ?? "0")"
    }
}

// MARK: - GlobalRate
struct GlobalRate: Codable {
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int?
    let newRecovered, totalRecovered: Int?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
    
    func returnLastUpdatedOn() -> String {
        let updatedAgo = date?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")?.timeAgoSinceDate()
        return "Last updated \(updatedAgo ?? "0")"
    }
}
