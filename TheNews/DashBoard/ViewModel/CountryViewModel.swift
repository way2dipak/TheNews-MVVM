//
//  CountryViewModel.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

struct CountryViewModel {
    var name: String
    var alpha2code: String
    var alpha3code: String
    var latitude: Double
    var longitude: Double
    
    init(details: CountryModel) {
        self.name = details.name ?? ""
        self.alpha2code = details.alpha2code ?? ""
        self.alpha3code = details.alpha3code ?? ""
        self.latitude = details.latitude ?? 0.0
        self.longitude = details.longitude ?? 0.0
    }
}
