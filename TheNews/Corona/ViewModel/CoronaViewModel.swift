//
//  CoronaViewModel.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

class CoronaViewModel {
    
    enum HeaderSection {
        case country
        case dashboard
        case worldwide
    }
    var sectionList: [HeaderSection] = [.country, .dashboard, .worldwide]
    var coronaDetails: CoronaResponse?
    var refreshUI: (() -> ())?
    var errorUI: (() -> ())?
    
    private var service = CoronaDataManager()
    
    func numberOfRowsInSection(section: Int) -> Int {
        return sectionList.count
    }
    
    func sectionNameBasedOnRows(index: IndexPath) -> HeaderSection {
        return sectionList[index.row]
    }
    
    func getAllCountryList() -> [Country] {
        return coronaDetails?.countries ?? []
    }
    
    func getDetailsBasedOnCountry(code: String) -> Country? {
        return coronaDetails?.countries?.filter({ $0.countryCode?.lowercased() ?? "" == code.lowercased() }).first
    }
    
    func getDefaultCountryDetails() -> Country? {
        return coronaDetails?.countries?.filter({ $0.countryCode?.lowercased() ?? "" == "in" }).first
    }
    
    func fetchCoronaWorldWideSummary() {
        service.fetchCoronaWorldWideSummary { [weak self] response in
            guard let self = self else { return }
            self.coronaDetails = response
            self.refreshUI?()
        }
    }
}
