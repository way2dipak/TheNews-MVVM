//
//  SearchService.swift
//  TheNews
//
//  Created by DS on 06/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class CoronaService: NSObject {
    
    func getCoronaResultByCountry(countryCode code: String, result: @escaping(([CoronaViewModel])->()), error: @escaping((String)->())) {
//        let url = "https://covid-19-data.p.rapidapi.com/country/code?format=json&code=\(code)"
//        NetworkManager.shared.httpRequestWith(link: url, method: .GET, headers: Global.shared.coronaApiHeaders, params: [:], onSuccess: { (response: [CoronaModel]) in
//            if response.count != 0 {
//                var vwModelArray = [CoronaViewModel]()
//                for value in response {
//                    vwModelArray.append(CoronaViewModel(details: value))
//                    result(vwModelArray)
//                }
//            }
//        }) { (message) in
//            error(message)
//        }
    }
    
}


