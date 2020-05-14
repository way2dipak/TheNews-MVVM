//
//  CountryModel.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation


struct CountryModel: Codable {
    var name: String?
    var alpha2code: String?
    var alpha3code: String?
    var latitude: Double?
    var longitude: Double?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case alpha2code
        case alpha3code
        case latitude
        case longitude
        case message
    }
}

