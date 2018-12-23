//
//  Categories.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor
import Fluent

struct CategoryController: RouteCollection {
    
    func boot(router: Router) throws {
        let categoryRoute = router.grouped("api", "categories")
        categoryRoute.post(use: createCategory)
        categoryRoute.get(use: getAllCategory)
        categoryRoute.get(Category.parameter, use: getCategory)
        categoryRoute.get(Category.parameter, "acronyms", use: getAcronyms)
    }
    
    // create category
    func createCategory(_ req: Request) throws -> Future<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req)
    }
    
    // get all categories
    func getAllCategory(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    // get category
    func getCategory(_ req: Request) throws -> Future<Category> {
        return try req.parameters.next(Category.self)
    }
    
    // get many acronym
    func getAcronyms(_ req: Request) throws -> Future<[Acronym]> {
        return try req.parameters.next(Category.self).flatMap(to: [Acronym].self) { category in
            try category.acronyms.query(on: req).all()
        }
    }
}
