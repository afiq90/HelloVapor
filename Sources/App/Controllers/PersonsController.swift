import Vapor

struct PersonsController: RouteCollection {
    func boot(router: Router) throws {
        let personsRoute = router.grouped("api", "person")
        personsRoute.get(use: getAllPersons)
        personsRoute.post(use: createPerson)
    }
    
    func getAllPersons(_ req: Request) throws -> Future<[Person]> {
        return Person.query(on: req).all()
    }
    
    func createPerson(_ req: Request) throws -> Future<Person> {
        let person = try req.content.decode(Person.self)
        return person.save(on: req)
    }
}
