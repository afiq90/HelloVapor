//
//  Car.swift
//  App
//
//  Created by Afiq Hamdan on 22/12/2018.
//

import Vapor
import FluentSQLite

struct Car: Codable {
    var id: Int?
    var model: String
    var color: String
    
    init(model: String, color: String) {
        self.model = model
        self.color = color
    }
    
}

extension Car: SQLiteModel {}
extension Car: Content {}
extension Car: Migration {}
