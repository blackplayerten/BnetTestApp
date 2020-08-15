//
//  SessionProcessor.swift
//  BnetTestApp
//
//  Created by a.kurganova on 13.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation
import PromiseKit

protocol SessionProcessorProtocol: class {
    func getToken() -> Promise<String>
    func getSession(token: String) -> Promise<String>
}

final class SessionProcessor: SessionProcessorProtocol {
    func getToken() -> Promise<String> {
        let params = [
        "name": "Александра Курганова",
        "email": "kurganova06.1998@gmail.com",
        "a": "get_token"
        ]

        return Promise<String> { seal in
            URLSession.shared.dataTask(with: makeRequest(token: nil, httpBodyParameters: params))
            { (data, response, error) in
                if let error = error {
                    print(error)
                    switch error as? NetworkErrors {
                    case .invalidPath:
                        seal.reject(NetworkErrors.invalidPath)
                    default:
                        seal.reject(NetworkErrors.unknown)
                    }
                    return
                }

                if let response = response as? HTTPURLResponse {
                    let status = response.statusCode
                    switch status {
                    case 200:
                        break
                    case 404:
                        seal.reject(NetworkErrors.invalidToken)
                    case 500:
                        seal.reject(NetworkErrors.noToken)
                    default:
                        seal.reject(NetworkErrors.unknown)
                    }
                }

                guard let data = data else {
                    seal.reject(NetworkErrors.invalidToken)
                    return
                }

                do {
                    let tokenObject = try JSONDecoder().decode(TokenJsonObject.self, from: data)
                    seal.fulfill(tokenObject.data.token)
                } catch let error {
                    print(error)
                    seal.reject(NetworkErrors.unknown)
                }
            }.resume()
        }
    }

    func getSession(token: String) -> Promise<String> {
        return Promise<String> { seal in
            let params = [ "a": "new_session" ]
            
            URLSession.shared.dataTask(with: makeRequest(token: token,
                                                         httpBodyParameters: params))
            { (data, response, error) in
                if let error = error {
                    print(error)
                    switch error as? NetworkErrors {
                    case .invalidPath:
                        seal.reject(NetworkErrors.invalidPath)
                    default:
                        seal.reject(NetworkErrors.unknown)
                    }
                    return
                }

                if let response = response as? HTTPURLResponse {
                    let status = response.statusCode
                    switch status {
                    case 200:
                        break
                    case 404:
                        seal.reject(NetworkErrors.invalidToken)
                    case 500:
                        seal.reject(NetworkErrors.noToken)
                    default:
                        seal.reject(NetworkErrors.unknown)
                    }
                }

                guard let data = data else {
                    seal.reject(NetworkErrors.invalidToken)
                    return
                }

                do {
                    let sessionObject = try JSONDecoder().decode(SessionJsonObject.self, from: data)
                    seal.fulfill(sessionObject.data.session)
                } catch let error {
                    print(error)
                    seal.reject(NetworkErrors.unknown)
                }
            }.resume()
        }
    }
}
