//
//  APIRequest.swift
//  TheNews
//
//  Created by Dipak Singh on 27/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

public struct APIRequest {
    var baseURL: String = ""
    var path: String
    var method: HTTPMethod
    var headers: [String: String]
    var params: [String: Any]
    var token: String?
    var encodeURL: Bool
    
    init(baseURL: String = "",
         path: String,
         method: HTTPMethod,
         headers: [String: String] = [:],
         params: [String: Any] = [:],
         token: String? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.params = params
        self.token = token
        self.encodeURL = true
    }
    
    func constructURLRequest() -> URLRequest {
        let url = ((baseURL != "" ? baseURL : APIBase.currentEnv.baseUrl) + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        var urlRequest = URLRequest(url: URL(string: url)!, timeoutInterval: 60)
        if headers.count != 0 {
            urlRequest.allHTTPHeaderFields = headers
        } else {
            urlRequest.allHTTPHeaderFields = ["x-api-key": Global.shared.apikey]
        }
        if method == .POST {
            let postData = try? JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = postData
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
