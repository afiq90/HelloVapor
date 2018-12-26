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
        movieRouter.get(Movie.parameter, use: getMovie)
        movieRouter.post(use: createMovie)
        movieRouter.delete(Movie.parameter, use: deleteMovie)
        movieRouter.put(Movie.parameter, use: updateMovie)
        movieRouter.get(Movie.parameter, "creator", use: getMovieCreatorHandler)
    }
    
    func getAllMovie(_ req: Request) throws -> Future<[Movie]> {
        return Movie.query(on: req).all()
    }
    
    // Get individual id
    func getMovie(_ req: Request) throws -> Future<Movie> {
        return try req.parameters.next(Movie.self)
    }
    
    func getMovieCreatorHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(Movie.self).flatMap(to: User.self) { movie in
            return movie.creator.get(on: req)
        }
    }
    
    
    func createMovie(_ req: Request) throws -> Future<Movie> {
        let movie = try req.content.decode(Movie.self)
        return movie.save(on: req)
    }
    
    // Delete API
    
    func deleteMovie(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Movie.self).flatMap(to: HTTPStatus.self) { movie in
            return movie.delete(on: req).transform(to: .noContent)
        }

    }
    
    // update API
    func updateMovie(_ req: Request) throws -> Future<Movie> {
        return try flatMap(to: Movie.self, req.parameters.next(Movie.self), req.content.decode(Movie.self), { movie, updatedMovie in
            movie.title = updatedMovie.title
            movie.year = updatedMovie.year
            return movie.save(on: req)
        })
    }
    
    
}

