//
//  Person.swift
//  App
//
//  Created by Afiq Hamdan on 22/12/2018.
//

import Vapor
import FluentMySQL

final class Person: Codable {
    var id: Int?
    var name: String
    var age: Int
    var address: String
    var isForeverAlone: Bool
    
    init(name: String, age: Int, address: String, isForeverAlone: Bool) {
        self.name = name
        self.age = age
        self.address = address
        self.isForeverAlone = isForeverAlone
    }
    
}

extension Person: MySQLModel {}
extension Person: Content {}
extension Person: Migration {}
