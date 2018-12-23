//
//  User.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor
import FluentSQLite

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User: SQLiteUUIDModel {}
extension User: Content {}
extension User: Parameter {}
extension User: Migration {}

// User- Acronym relationship
// User have many acronyms
extension User {
    var acronyms: Children<User, Acronym> {
        return children(\.creatorID)
    }
}
