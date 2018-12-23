//
//  WebsiteController.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor
import Leaf

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.get("acronyms", Acronym.parameter, use: acronymHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        return Acronym.query(on: req).all().flatMap(to: View.self) { acronyms in
            let context = IndexContent(title: "HomePage", acronyms: acronyms.isEmpty ? nil : acronyms)
            for acronym in acronyms {
                print(acronym.short)
            }
            return try req.leaf().render("index", context)
        }
    }
    
    func acronymHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Acronym.self).flatMap(to: View.self) { acronym in
            return acronym.creator.get(on: req).flatMap(to: View.self) { creator in
                let context = AcronymContext(title: acronym.long, acronym: acronym, creator: creator)
                return try req.leaf().render("acronym", context)
            }
        }
    }
    
//    func acronymHandler(_ req: Request) throws -> Future<View> {
//        return try req.parameters.next(Acronym.self).flatMap(to: View.self) { acronym in
//            return acronym.creator.get(on: req).flatMap(to: View.self) { creator in
//                let context = AcronymContext(title: acronym.long, acronym: acronym, creator: creator)
//                return try req.leaf().render("acronym", context)
//            }
//        }
//    }
    
}

extension Request {
    func leaf() throws -> LeafRenderer {
        return try self.make(LeafRenderer.self)
    }
}

struct IndexContent: Encodable {
    let title: String
    let acronyms: [Acronym]?
}

struct AcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let creator: User
}
