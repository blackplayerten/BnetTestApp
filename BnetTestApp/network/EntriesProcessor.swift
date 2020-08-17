//
//  EntriesProcessor.swift
//  BnetTestApp
//
//  Created by a.kurganova on 13.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation

protocol EntriesProcessorProtocol: class {
    func getEntries(token: String, session: String, completion: ((EntriesJsonObject?, NetworkErrors?) -> Void)?)
    func addEntry(token: String, session: String, body: String,
                  completion: ((AddEntryJsonObject?, NetworkErrors?) -> Void)?)
}

final class EntriesProcessor: EntriesProcessorProtocol {
    func getEntries(token: String, session: String, completion: ((EntriesJsonObject?, NetworkErrors?) -> Void)?) {
        let params = [
            "a": "get_entries",
            "session": session
        ]

        URLSession.shared.dataTask(with: makeRequest(token: token,
                                                     httpBodyParameters: params)) { (data, response, error) in
            if let error = error {
                print(error)
                if error.localizedDescription == "The Internet connection appears to be offline." {
                    completion?(nil, .noConnection)
                } else {
                    completion?(nil, .unknown)
                }
                return
            }

            if let response = response as? HTTPURLResponse {
                let status = response.statusCode
                switch status {
                case 200:
                    break
                case 404:
                    completion?(nil, .invalidToken)
                case 500:
                    completion?(nil, .noToken)
                default:
                    completion?(nil, .unknown)
                }
            }

            guard let data = data else {
                completion?(nil, .unknown)
                return
            }

            do {
                let entriesObject = try JSONDecoder().decode(EntriesJsonObject.self, from: data)
                completion?(entriesObject, nil)
            } catch let error {
                print(error)
                completion?(nil, .unknown)
            }
        }.resume()
    }
    
    func addEntry(token: String, session: String, body: String,
                  completion: ((AddEntryJsonObject?, NetworkErrors?) -> Void)?) {
        let params = [
            "a": "add_entry",
            "session": session,
            "body": body
        ]

        URLSession.shared.dataTask(with: makeRequest(token: token, httpBodyParameters: params))
        { (data, response, error) in
            if let error = error {
                print(error)
                if error.localizedDescription == "The Internet connection appears to be offline." {
                    completion?(nil, .noConnection)
                } else {
                    completion?(nil, .unknown)
                }
                return
            }

            if let response = response as? HTTPURLResponse {
                let status = response.statusCode
                switch status {
                case 200:
                    break
                case 404:
                    completion?(nil, .invalidToken)
                case 500:
                    completion?(nil, .noToken)
                default:
                    completion?(nil, .unknown)
                }
            }

            guard let data = data else {
                completion?(nil, .unknown)
                return
            }

            do {
                let entryObject = try JSONDecoder().decode(AddEntryJsonObject.self, from: data)
                completion?(entryObject, nil)
            } catch let error {
                print(error)
                completion?(nil, .unknown)
            }
        }.resume()
    }
}
