import Alamofire

// Struct to compose Alamofire request
struct TmdbPopularRequest: TmdbRequestConvertible {
    let endpoint: String
    let apiKey: String

    // The parameters we know at the build time
    let parameters: Parameters? = nil
    let path: String = "movie/popular"
    let method: HTTPMethod = .get
}
