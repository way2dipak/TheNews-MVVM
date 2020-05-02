//
//  NetworkManager.swift
//  Prototype
//
//  Created by Embibe on 27/01/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
    }
    
    private var session = URLSession.shared {
        didSet {
            self.session.configuration.timeoutIntervalForRequest = TimeInterval(60)
        }
    }
    private var task: URLSessionDataTask? = nil
    
    func httpRequestWith<T : Codable>(link: String, method: HTTPMethod, headers: [String:String], params: [String:Any], model: T.Type, onSuccess: @escaping((T)->()), onFailure: @escaping((String)->())) {
        let url = URL(string: link.replacingOccurrences(of: " ", with: "%20"))!
        var urlRequest = URLRequest(url: url)
        print("URLRequest: \(urlRequest)")
        if headers.count != 0 {
            urlRequest.allHTTPHeaderFields = headers
        }
        else {
            urlRequest.allHTTPHeaderFields = [
                "content-type": "application/json"
            ]
        }
        if method == .POST {
            let postData = try! JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = postData
        }
        urlRequest.httpMethod = method.rawValue
        
        task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                onFailure(error!.localizedDescription)
            }
            else {
                if let newData = data {
                    let dict = try! JSONSerialization.jsonObject(with: newData, options: .mutableContainers) as? [String:Any] ?? [:]
                    print("Response: \(dict)")
                    
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(model.self, from: newData)
                        onSuccess(result)
                    }
                    catch(let catchError) {
                        onFailure(catchError.localizedDescription)
                    }
                }
                else {
                    onFailure("Server Error")
                }
            }
        })
        task?.resume()
    }
}
