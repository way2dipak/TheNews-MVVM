//
//  CoronaModel.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation


struct CoronaModel: Codable {
    var country: String
    var code: String
    var confirmed: Int
    var recovered: Int
    var critical: Int
    var deaths: Int
    var latitude: Decimal
    var longitude: Decimal
    var lastChange: String?
    var lastUpdate: String?
    
    enum CodingKeys: String, CodingKey {
        case country
        case code
        case confirmed
        case recovered
        case critical
        case deaths
        case latitude
        case longitude
        case lastChange
        case lastUpdate
    }
    
}

