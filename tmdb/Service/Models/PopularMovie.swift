import Foundation

// The popular movie model
struct PopularMovie: Codable {
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w342"

    let id: Int
    let title: String
    let posterPath: String?

    var posterUrl: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: PopularMovie.imageBaseUrl + path)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}

extension PopularMovie: Equatable {
    public static func == (lhs: PopularMovie, rhs: PopularMovie) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.posterPath == rhs.posterPath
    }
}
