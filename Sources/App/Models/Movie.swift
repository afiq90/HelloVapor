//
//  Movie.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor
import FluentMySQL

final class Movie: Codable {
    var id: Int?
    var title: String
    var actors: [Actors]?
    var year: Int
    
    init(title: String, year: Int) {
        self.title = title
        self.year = year
//        self.actors = actors
    }
}

final class Actors: Codable {
    var name: String
    var age: Int
}

extension Movie: MySQLModel {}
extension Movie: Content {}
extension Movie: Migration {}
