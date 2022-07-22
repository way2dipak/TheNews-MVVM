//
//  Environment.swift
//  TheNews
//
//  Created by Dipak Singh on 27/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

public struct APIBase {
    public static var currentEnv = Environment.dev
}

public enum Environment {
    
    case dev
    case staging
    case prod

    public var baseUrl: String {
        switch self {
        case .dev:
            return "https://newsapi.org/v2/"
        case .staging:
            return "https://newsapi.org/v2/"
        case .prod:
            return "https://newsapi.org/v2/"
        }
    }
}
