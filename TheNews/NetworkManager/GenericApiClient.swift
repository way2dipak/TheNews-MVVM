//
//  GenericApiClient.swift
//  TheNews
//
//  Created by Dipak Singh on 27/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
}

enum APIError: String, Error {
    case clientError
    case serverError
    case noData
    case dataDecodingError
}

protocol APIClientProtocol {
    func fetchData(_ request: APIRequest,
                               completion: @escaping (Result<Data, APIError> ) -> ())
}

extension APIClientProtocol {
    func fetchData(_ request: APIRequest,
                               completion: @escaping (Result<Data,APIError>) -> ()) {
        
        let task = URLSession.shared.dataTask(with: request.constructURLRequest()) { data, response, error in
            if let _ = error {
                completion(.failure(.clientError))
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 429 {
                DispatchQueue.main.async {
                    AppDelegate.shared.displayUsageUI()
                }
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] ?? [:]
            print("==============response start================\n")
            print(jsonData ?? [:])
            print("\n==============response start================")
            completion(.success(data))
        }
        task.resume()
    }
    
    func checkDailyLimitUsage(statusCode: Int) {
        
    }
}
