//
//  Users.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor

class UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let userRoute = router.grouped("api", "users")
        userRoute.post(use: createUser)
        userRoute.get(use: getAllUsers)
        userRoute.get(User.parameter, use: getUser)
        userRoute.get(User.parameter, "acronyms", use: getAcronymsHandler)
    }
    
    // create user
    func createUser(_ req: Request) throws -> Future<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req)
    }
    
    // get all users
    func getAllUsers(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    // get user
    func getUser(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    // get all acronyms by user
    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        return try req.parameters.next(User.self).flatMap(to: [Acronym].self) { user in
            return try user.acronyms.query(on: req).all()
        }
    }
    
}
