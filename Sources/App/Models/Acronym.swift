
import Vapor
import FluentSQLite

final class Acronym: Codable {
    var id: Int?
    var long: String
    var short: String
    
    init(long: String, short: String) {
        self.long = long
        self.short = short
    }
}

extension Acronym: SQLiteModel {}
extension Acronym: Content {}
extension Acronym: Migration {}
