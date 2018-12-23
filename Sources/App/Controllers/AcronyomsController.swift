import Vapor

struct AcronymsController: RouteCollection {
    func boot(router: Router) throws {
        // make a API path : API/acronym
        let acronymsRoute = router.grouped("api", "acronyms")
        acronymsRoute.get(use: getAllHandler)
        acronymsRoute.get(Acronym.parameter, use: getAcronymHandler)
        acronymsRoute.post(use: postAllHandler)
        acronymsRoute.get(Acronym.parameter, "creator", use: getCreatorHandler)
        acronymsRoute.get(Acronym.parameter, "categories", use: getCategories)
        acronymsRoute.post(Acronym.parameter, "categories", Category.parameter, use: addCategories)
    }

    func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }
    
    func postAllHandler(_ req: Request) throws -> Future<Acronym> {
        let acronym = try req.content.decode(Acronym.self)
        return acronym.save(on: req)
    }
    
    func getAcronymHandler(_ req: Request) throws -> Future<Acronym> {
        return try req.parameters.next(Acronym.self)
    }
    
    func getCreatorHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(Acronym.self).flatMap(to: User.self) { acronym in
            return acronym.creator.get(on: req)
        }
    }
    
    func getCategories(_ req: Request) throws -> Future<[Category]> {
        return try req.parameters.next(Acronym.self).flatMap(to: [Category].self) { acronym in
            try acronym.categories.query(on: req).all()
        }
    }
    
    func addCategories(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Acronym.self), req.parameters.next(Category.self)) { acronym, category in
            let pivot = try AcronymCategoryPivot(acronymID: acronym.requireID(), categoryID: category.requireID())
            return pivot.save(on: req).transform(to: .ok)
        }
    }
    
}
