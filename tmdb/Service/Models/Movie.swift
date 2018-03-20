import Foundation

// The movie model
struct Movie: Codable {
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w780"

    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let genres: [Genre]
    let releaseDate: Date

    // Property to return poster URL
    var posterUrl: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: Movie.imageBaseUrl + path)
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, overview, genres
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

extension Movie: Equatable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.overview == rhs.overview &&
            lhs.posterPath == rhs.posterPath &&
            lhs.genres == rhs.genres &&
            lhs.releaseDate == rhs.releaseDate
    }
}
