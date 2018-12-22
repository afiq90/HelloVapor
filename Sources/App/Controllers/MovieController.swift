//
//  MovieController.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Vapor

class MovieController: RouteCollection {
    func boot(router: Router) throws {
        let movieRouter = router.grouped("api", "movies")
        movieRouter.get(use: getAllMovie)
        movieRouter.post(use: createMovie)
    }
    
    func getAllMovie(_ req: Request) throws -> Future<[Movie]> {
        return Movie.query(on: req).all()
    }
    
    func createMovie(_ req: Request) throws -> Future<Movie> {
        let movie = try req.content.decode(Movie.self)
        return movie.save(on: req)
    }
}
