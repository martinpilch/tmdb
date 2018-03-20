import Alamofire

// Service to get movie detail
class TmdbMovieService: TmdbServicable {
    typealias ResultType = Movie

    let endpoint: String
    let apiKey: String
    let movieId: Int
    let sessionManager: SessionManager

    required init(endpoint: String, apiKey: String, movieId: Int, sessionManager: SessionManager = Alamofire.SessionManager.default) {
        self.endpoint = endpoint
        self.apiKey = apiKey
        self.movieId = movieId
        self.sessionManager = sessionManager
    }

    func perform(onComplete: @escaping (Loadable<ResultType>) -> Void) {
        let request = TmdbMovieRequest(endpoint: endpoint, apiKey: apiKey, movieId: movieId)
        sessionManager.request(request)
            .response { response in
                guard let data = response.data, data.count > 0 else {
                    onComplete(.failure(.noDataError))
                    return
                }

                // Parse date info correctly using custom formatter
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
                
                guard let movie = try? decoder.decode(ResultType.self, from: data) else {
                    onComplete(.failure(.jsonDecodingError))
                    return
                }

                onComplete(.success(movie))
        }
    }
}
