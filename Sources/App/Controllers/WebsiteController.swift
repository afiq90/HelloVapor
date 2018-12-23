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
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        let context = IndexContent(title: "Meow 😺")
        return try req.leaf().render("index", context)
    }
    
}

extension Request {
    func leaf() throws -> LeafRenderer {
        return try self.make(LeafRenderer.self)
    }
}

struct IndexContent: Encodable {
    let title: String
}
