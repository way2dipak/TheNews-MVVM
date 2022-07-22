//
//  NetworkManager.swift
//  Prototype
//
//  Created by Embibe on 27/01/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class NetworkManagerClient: APIClientProtocol {
    func httpRequestWith<T: Codable>(_ request: APIRequest, completion: @escaping ((T) -> ()), failure: @escaping ((String?)->())) {
        print("URLRequest: \(request)")
        fetchData(request) { response in
            switch response {
            case .success(let results):
                do {
                    let value = try JSONDecoder().decode(T.self, from: results)
                    completion(value)
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                    failure(APIError.dataDecodingError.rawValue)
                }
                
            case .failure(let error):
                failure(error.rawValue)
            }
        }
    }
}
