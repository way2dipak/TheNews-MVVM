//
//  CoronaDataManager.swift
//  TheNews
//
//  Created by Dipak Singh on 17/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

class CoronaDataManager {
    private let network = NetworkManagerClient()
    
    func fetchCoronaWorldWideSummary(completion: @escaping((CoronaResponse?) -> Void)) {
        let request = URLRepository.corona.dataRequest
        network.httpRequestWith(request) { [weak self] (response: CoronaResponse) in
            guard let _ = self else { return }
            completion(response)
        } failure: { error in
            print("Error: \(error ?? "")")
        }

    }
}
