//
//  Car.swift
//  App
//
//  Created by Afiq Hamdan on 22/12/2018.
//

import Vapor
import FluentMySQL

struct Car: Codable {
    var id: Int?
    var model: String
    var color: String
    
    init(model: String, color: String) {
        self.model = model
        self.color = color
    }
    
}

extension Car: MySQLModel {}
extension Car: Content {}
extension Car: Migration {}
