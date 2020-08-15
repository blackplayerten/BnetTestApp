//
//  parseObjects.swift
//  BnetTestApp
//
//  Created by a.kurganova on 13.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation

struct TokenJsonObject: Decodable {
    var status: Int
    var data: TokenObject
}

struct TokenObject: Decodable {
    var token: String
}

struct SessionJsonObject: Decodable {
    var status: Int
    var data: SessionObject
}

struct SessionObject: Decodable {
    var session: String
}

struct EntriesJsonObject: Decodable {
    var status: Int
    var data: [[EntitiesArrayObject]]
}

struct EntitiesArrayObject: Decodable {
    var id: String
    var body: String
    var da: String
    var dm: String
}

struct AddEntryJsonObject: Decodable {
    var status: Int
    var data: AddingEntryObject
}

struct AddingEntryObject: Decodable {
    var id: String
}
