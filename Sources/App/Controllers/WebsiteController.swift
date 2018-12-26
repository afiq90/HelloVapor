//
//  WebsiteController.swift
//  App
//
//  Created by Afiq Hamdan on 23/12/2018.
//

import Foundation
import Vapor
import Leaf

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.get("acronym", Acronym.parameter, use: acronymHandler)
        router.get("user", User.parameter, use: userHandler)
        router.get("users", use: usersHandler)
        router.get("category", Category.parameter, use: categoryHandler)
        router.get("categories", use: categoriesHandler)
        router.get("create-acronym", use: createAcronymHandler)
        router.post("create-acronym", use: createAcronymPostHandler)
        router.get("acronyms", Acronym.parameter, "edit", use: editAcronymHandler)
        router.post("acronyms", Acronym.parameter, "edit", use: editAcronymPostHandler)
        router.post("acronyms", Acronym.parameter, "delete", use: deleteAcronymHandler)
        
        router.get("movies", use: getAllMovieHandler)
        router.get("movie", Movie.parameter, use: movieHandler)
        router.get("create-movie", use: createMovieHandler)
        router.post("create-movie", use: createMoviePostHandler)

    }
    
    /* Website Index */

    func indexHandler(_ req: Request) throws -> Future<View> {
        return Acronym.query(on: req).all().flatMap(to: View.self) { acronyms in
            let context = IndexContent(title: "HomePage", acronyms: acronyms.isEmpty ? nil : acronyms)
            for acronym in acronyms {
                print(acronym.short)
            }
            return try req.leaf().render("index", context)
        }
    }
    
    /* Movie Handler */
    
    func movieHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Movie.self).flatMap(to: View.self) { movie in
            return movie.creator.get(on: req).flatMap(to: View.self) { creator in
                let context = MovieContext(title: "Movie 🎬 🎦", movieName: movie.title, movieYear: movie.year, creator: creator)
                return try req.leaf().render("movie", context)
            }
        }
        
    }
    
    func getAllMovieHandler(_ req: Request) throws -> Future<View> {
        return Movie.query(on: req).all().flatMap(to: View.self) { movies in
            let context = MoviesContext(title: "List of all movie", movies: movies.isEmpty ? nil : movies)
            return try req.leaf().render("movies", context)
        }
    }
    
    func createMovieHandler(_ req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap(to: View.self) { users in
            let context = createMovieContext(title: "Create New Movie", users: users)
            return try req.leaf().render("createMovie", context)
        }
    }
    
    func createMoviePostHandler(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(MoviePostData.self).flatMap(to: Response.self) { data in
            let movie = Movie(title: data.title, year: data.year, creatorID: data.creator)
            return movie.save(on: req).map(to: Response.self) { movie in
                guard let id = movie.id else {
                    return req.redirect(to: "/")
                }
                return req.redirect(to: "/movie/\(id)")
            }
        }
    }
    
    /* TODO:
        create edit ande delete functionality for movie
     */
    
    /* Acronym Handler */

    func acronymHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Acronym.self).flatMap(to: View.self) { acronym in
            return acronym.creator.get(on: req).flatMap(to: View.self) { creator in
                let context = AcronymContext(title: acronym.long, acronym: acronym, creator: creator)
                return try req.leaf().render("acronym", context)
            }
        }
    }
    
    func createAcronymHandler(_ req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap(to: View.self) { users in
            return Category.query(on: req).all().flatMap(to: View.self) { categories in
                let context = createAcronymContext(title: "Create An Acronym", users: users, categories: categories)
                return try req.leaf().render("createAcronym", context)
            }
        }
    }
    
    func createAcronymPostHandler(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(AcronymPostData.self).flatMap(to: Response.self) { data in
            let acronym = Acronym(long: data.acronymLong, short: data.acronymShort, creatorID: data.creator)
            return acronym.save(on: req).map(to: Response.self) { acronym in
                guard let id = acronym.id else {
                    return req.redirect(to: "/")
                }
                return req.redirect(to: "/acronyms/\(id)")
            }
        }
    }
    
    func editAcronymHandler(_ req: Request) throws -> Future<View> {
        return try flatMap(to: View.self, req.parameters.next(Acronym.self), User.query(on: req).all()) { acronym, users in
            let context = EditAcronymContext(title: "Edit Acronym", acronym: acronym, users: users)
            return try req.leaf().render("createAcronym", context)
        }
    }
    
    func editAcronymPostHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Acronym.self), req.content.decode(AcronymPostData.self)) { acronym, data in
            acronym.short = data.acronymShort
            acronym.long = data.acronymLong
            acronym.creatorID = data.creator
            
            return acronym.save(on: req).map(to: Response.self) { acronym in
                guard let id = acronym.id else {
                    return req.redirect(to: "/")
                }
                return req.redirect(to: "/acronyms/\(id)")
            }
        }
    }
    
    func deleteAcronymHandler(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(Acronym.self).flatMap(to: Response.self) { acronym in
            return acronym.delete(on: req).transform(to: req.redirect(to: "/"))
        }
    }
    
    /* User Handler */
    
    func userHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(User.self).flatMap(to: View.self) { user in
            return try user.acronyms.query(on: req).all().flatMap(to: View.self) { acronyms in
                let context = UserContext(title: user.name, user: user, acronyms: acronyms.isEmpty ? nil : acronyms)
                return try req.leaf().render("user", context)
            }
        }
    }
    
    func usersHandler(_ req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap(to: View.self) { users in
            let context = UsersContext(users: users.isEmpty ? nil : users)
            for user in users {
                print(user.name)
                print(user.username)
            }
            return try req.leaf().render("users", context)
        }
    }
    
    /* Category Handler */
    
    func categoryHandler(_ req: Request) throws -> Future<View>  {
        return try req.parameters.next(Category.self).flatMap(to: View.self) { category in
            return try category.acronyms.query(on: req).all().flatMap(to: View.self) { acronyms in
                let context = CategoryContext(name: category.name, category: category, acronyms: acronyms.isEmpty ? nil : acronyms)
                return try req.leaf().render("category", context)
            }
        }
    }
    
    
    func categoriesHandler(_ req: Request) throws -> Future<View> {
        return Category.query(on: req).all().flatMap(to: View.self) { categories in
            let context = CategoriesContext(categories: categories.isEmpty ? nil : categories)
            for category in categories {
                print(category.acronyms)
                print(category.name)
            }
            return try req.leaf().render("categories", context)
        }
    }
  
}

extension Request {
    func leaf() throws -> LeafRenderer {
        return try self.make(LeafRenderer.self)
    }
}

/* GET Method*/

struct IndexContent: Encodable {
    let title: String
    let acronyms: [Acronym]?
}

struct AcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let creator: User
}

struct UserContext: Encodable {
    let title: String
    let user: User
    let acronyms: [Acronym]?
}

struct UsersContext: Encodable {
    let users: [User]?
}

struct CategoryContext: Encodable {
    let name: String
    let category: Category
    let acronyms: [Acronym]?
}

struct CategoriesContext: Encodable {
    let categories: [Category]?
}

struct createAcronymContext: Encodable {
    let title: String
    let users: [User]
    let categories: [Category]
}

struct MovieContext: Encodable {
    let title: String
    let movieName: String
    let movieYear: Int
    let creator: User
}

struct MoviesContext: Encodable {
    let title: String
    let movies: [Movie]?
}

struct createMovieContext: Encodable {
    let title: String
    let users: [User]
//    let editing = true
}

/* POST Method */

struct AcronymPostData: Content {
    static var defaultMediaType = MediaType.urlEncodedForm
    let acronymLong: String
    let acronymShort: String
    let creator: UUID
}

struct MoviePostData: Content {
    static var defaultMediaType = MediaType.urlEncodedForm
    let title: String
    let year: Int
    let creator: UUID
}

struct EditAcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let users: [User]
    let editing = true
}



/*
 TODO:
 1) build all users page ✅
 2) build   page ✅
 3) build all categories page ✅
 */
