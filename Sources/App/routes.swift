import Vapor


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("date") { req in
        return "Today date is \(Date())"
    }
    
    router.post(Counter.self, at: "counter") { (req, data) -> Counter in
        return Counter(num: data.num)
    }
    
    router.post(UserInfo.self, at: "user-info") { (req, userInfo) -> String in
        return "Hello \(userInfo.name), you are \(userInfo.age)"
    }

    router.post(Meow.self, at: "meow") { (req, data) -> MeowData in
        return MeowData(data: data)
//        return "Sayang geng meow, name saya \(data.name)!"
    }
    
    router.post(InfoData.self, at: "info") { req, data -> String in
        return "Hello \(data.name)!"
    }
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    // Configuring for Acronym
    let acronymController = AcronymsController()
    try router.register(collection: acronymController)
    
    // Configuring for Person
    let personController = PersonsController()
    try router.register(collection: personController)
    
    // Configuring for Car
    let carController = CarsController()
    try router.register(collection: carController)
    
    // Configuring for Movie
    let movieController = MovieController()
    try router.register(collection: movieController)
    
    // Configuring for User
    let userController = UserController()
    try router.register(collection: userController)
    
    // Configuring for Category
    let categoryController = CategoryController()
    try router.register(collection: categoryController)
    
    // Configuring for WebsiteController
    let websiteController = WebsiteController()
    try router.register(collection: websiteController)

}

struct UserInfo: Content {
    let name: String
    let age: Int
}

struct Counter: Content {
    let num: Int
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

struct Meow: Content {
    let name: String
}

struct MeowData: Content {
    let data: Meow
}
