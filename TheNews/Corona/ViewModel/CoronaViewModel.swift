//
//  CoronaViewModel.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

class CoronaViewModel: Codable {
    var country: String
    var coronaData: CoronaModel?
    
    init(details: CoronaModel) {
        country = details.country.capitalized
        coronaData = details
    }
    
    func getWorldWideCoronaResult() {
        let url = "https://covid-19-data.p.rapidapi.com/totals?format=json"
        NetworkManager.shared.httpRequestWith(link: url, method: .GET, headers: Global.shared.coronaApiHeaders, params: [:], onSuccess: { [weak self](response: [CoronaModel]) in
            if response.count != 0 {
                self?.coronaData = response[0]
            }
            else {
                print("Empty Response")
            }
        }) { (message) in
            print("ErrorInCoronaViewModel: \(message)")
        }
    }
}
