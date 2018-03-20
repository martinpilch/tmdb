import Foundation

// The video model
struct Video: Codable {
    let key: String
}

extension Video: Equatable {
    public static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.key == rhs.key
    }
}
