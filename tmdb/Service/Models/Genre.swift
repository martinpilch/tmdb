import Foundation

// The genre model
struct Genre: Codable {
    let id: Int
    let name: String
}

extension Genre: Equatable {
    public static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
}
