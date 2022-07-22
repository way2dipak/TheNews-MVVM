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
    
    var apikey = ""
    
    var usageHandler: (() -> ())?
    
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
    
    //MARK: get differnce between two dates
    func differenceBetweenDate(currentDate: String = Date().toString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
                               targetDate: String = "",
                               epochTargetDate: Int = 0,
                               dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",//yyyy-MM-dd'T'HH:mm:ss.SSSZ
                               isEpoch: Bool = false) -> Int {
        var target = Date()
        let calendar = Calendar.current
        
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = dateFormat
        let current = currentDateFormatter.date(from: Date().toString(format: dateFormat)) ?? Date()

        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = dateFormat
        if isEpoch {
            let epochDate = Date(timeIntervalSince1970: (Double(epochTargetDate) / 1000))
            let epochStr = targetDateFormatter.string(from: epochDate)
            target = targetDateFormatter.date(from: epochStr) ?? Date()
        } else {
            target = targetDateFormatter.date(from: targetDate) ?? Date()
        }
        
        let date1 = calendar.startOfDay(for: current)
        let date2 = calendar.startOfDay(for: target)
        
        let components = calendar.dateComponents([.hour], from: date1, to: date2)
        let hour = components.hour ?? 0
        return hour
    }
}


