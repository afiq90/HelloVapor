
import Vapor
import FluentSQLite

final class Acronym: Codable {
    var id: Int?
    var long: String
    var short: String
    var creatorID: User.ID
    
    init(long: String, short: String, creatorID: User.ID) {
        self.long = long
        self.short = short
        self.creatorID = creatorID
    }
}

extension Acronym: SQLiteModel {}
extension Acronym: Content {}
extension Acronym: Migration {}
extension Acronym: Parameter {}

// parent - child relationship
// acronym belongs to one user

extension Acronym {
    // computed property
    var creator: Parent<Acronym, User> {
        return parent(\.creatorID)
    }
}
