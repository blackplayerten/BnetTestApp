//
//  NetworkScheme.swift
//  BnetTestApp
//
//  Created by a.kurganova on 13.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation

func makeRequest(token: String?, httpBodyParameters: [String: String]) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    if token != nil {
        request.setValue(token, forHTTPHeaderField: "token")
    }
    let  params = httpBodyParameters.map { (key, value) in
         "\(key)=\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    .joined(separator: "&")
    .data(using: .utf8)
    request.httpBody = params
    
    return request
}

var url: URL {
    get {
        guard let url = URL(string: "https://bnet.i-partner.ru/testAPI/") else {
            return URL(string: "localhost")!
        }
        return url
    }
}

enum NetworkErrors: Error {
    case noToken
    case invalidToken
    case noSessionParameter
    case invalidPath
    case noConnection
    case unknown
}
