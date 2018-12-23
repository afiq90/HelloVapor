//
//  Category.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor
import FluentSQLite

final class Category: Codable {
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Category: SQLiteModel {}
extension Category: Content {}
extension Category: Migration {}
extension Category: Parameter {}
