import Vapor

struct AcronymsController: RouteCollection {
    func boot(router: Router) throws {
        // make a API path : API/acronym
        let acronymsRoute = router.grouped("api", "acronyms")
        acronymsRoute.get(use: getAllHandler)
        acronymsRoute.post(use: postAllHandler)
    }

    func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }
    
    func postAllHandler(_ req: Request) throws -> Future<Acronym> {
        let acronym = try req.content.decode(Acronym.self)
        return acronym.save(on: req)
    }
    
}
