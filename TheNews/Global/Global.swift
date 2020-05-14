//
//  UserObject.swift
//  TheNews
//
//  Created by Nisha Poddar on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class Global {
    static let shared = Global()
    
    var userObj: UserModel?
    var country = [CountryViewModel]()
    
    var coronaApiHeaders: [String:String] = [
        "x-rapidapi-host" : "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key" : "3bd8deb81fmsh9101e25de8888efp1f5e8ejsnd86b066ee441"
    ]
    
    var clientID = "158956149929-mssrkg88kb4j7r93cioi9ivp14roil9h.apps.googleusercontent.com"
    
    func formatNumber(_ n: Int) -> String {
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            let formatted = (num / 1_000_000_000)
            let val = String(format: "%.1f", formatted)
            if val.hasSuffix(".0") {
                return String(format: "%.0f", formatted) + "B"
            }
            else {
                return String(format: "%.1f", formatted) + "B"
            }
            
        case 1_000_000...:
            let formatted = (num / 1_000_000)
            let val = String(format: "%.1f", formatted)
            if val.hasSuffix(".0") {
                return String(format: "%.0f", formatted) + "M"
            }
            else {
                return String(format: "%.1f", formatted) + "M"
            }
            
        case 1_000...:
            let formatted = (num / 1_000)
            let val = String(format: "%.1f", formatted)
            if val.hasSuffix(".0") {
                return String(format: "%.0f", formatted) + "K"
            }
            else {
                return String(format: "%.1f", formatted) + "K"
            }
            
        case 0...:
            return "\(n)"
        default:
            return "\(sign)\(n)"
        }
    }
}


