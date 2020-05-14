//
//  SetupService.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation


class SetupService {
    
    func fetchAllCountryList(result: @escaping (([CountryViewModel])->()), error: @escaping ((String)->())) {
        let url = "https://covid-19-data.p.rapidapi.com/help/countries"
        NetworkManager.shared.httpRequestWith(link: url, method: .GET, headers: Global.shared.coronaApiHeaders, params: [:], onSuccess: { (response: [CountryModel]) in
            if response.count != 0 {
                var countryListArray = [CountryViewModel]()
                for value in response {
                    countryListArray.append(CountryViewModel(details: value))
                }
                result(countryListArray)
            }
            else {
                error("Unable to get Country List")
            }
        }) { (message) in
            error(message)
        }
    }
    
}
