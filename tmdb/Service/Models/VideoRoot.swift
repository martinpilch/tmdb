import Foundation

// The root of the Video response
struct VideoRoot: Codable {
    let id: Int
    let results: [Video]
}

extension VideoRoot: Equatable {
    public static func == (lhs: VideoRoot, rhs: VideoRoot) -> Bool {
        return lhs.id == rhs.id && lhs.results == rhs.results
    }
}
