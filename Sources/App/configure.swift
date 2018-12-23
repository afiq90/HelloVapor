import FluentMySQL
import Vapor
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())
    try services.register(LeafProvider())


    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)


    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    let dbConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "afiq", password: "password", database: "Vapor", transport: MySQLTransportConfig.unverifiedTLS)
    let database = MySQLDatabase(config: dbConfig)
    databases.add(database: database, as: .mysql)
    databases.enableLogging(on: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .mysql)
    migrations.add(model: Acronym.self, database: .mysql)
    migrations.add(model: Person.self, database: .mysql)
    migrations.add(model: Car.self, database: .mysql)
    migrations.add(model: Movie.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Category.self, database: .mysql)
    migrations.add(model: AcronymCategoryPivot.self, database: .mysql)
    services.register(migrations)

}
