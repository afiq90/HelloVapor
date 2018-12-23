//
//  AcronymCategoryPivot.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor
import FluentMySQL
import Foundation

final class AcronymCategoryPivot: MySQLUUIDPivot {
    var id: UUID?
    var acronymID: Acronym.ID
    var categoryID: Category.ID
    
    typealias Left = Acronym
    typealias Right = Category
    
    static let leftIDKey: LeftIDKey = \AcronymCategoryPivot.acronymID
    static let rightIDKey: RightIDKey = \AcronymCategoryPivot.categoryID
    
    init(acronymID: Acronym.ID, categoryID: Category.ID) {
        self.acronymID = acronymID
        self.categoryID = categoryID
    }
}

extension AcronymCategoryPivot: Migration {}

