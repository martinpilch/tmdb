import Alamofire

// Struct to compose Alamofire request
struct TmdbMovieRequest: TmdbRequestConvertible {
    let endpoint: String
    let apiKey: String
    let path: String

    // The parameters we know at the build time
    let parameters: Parameters? = nil
    let method: HTTPMethod = .get

    init(endpoint: String, apiKey: String, movieId: Int) {
        self.endpoint = endpoint
        self.apiKey = apiKey
        self.path = "movie/\(movieId)"
    }
}
