import Alamofire

// Service to get popular movies
class TmdbPopularService: TmdbServicable {
    typealias ResultType = PopularMovieRoot
    
    let endpoint: String
    let apiKey: String
    let sessionManager: SessionManager

    required init(endpoint: String, apiKey: String, sessionManager: SessionManager = Alamofire.SessionManager.default) {
        self.endpoint = endpoint
        self.apiKey = apiKey
        self.sessionManager = sessionManager
    }

    func perform(onComplete: @escaping (Loadable<ResultType>) -> Void) {
        let request = TmdbPopularRequest(endpoint: endpoint, apiKey: apiKey)
        sessionManager.request(request)
            .response { response in
                guard let data = response.data, data.count > 0 else {
                    onComplete(.failure(.noDataError))
                    return
                }

                guard let root = try? JSONDecoder().decode(ResultType.self, from: data) else {
                    onComplete(.failure(.jsonDecodingError))
                    return
                }

                onComplete(.success(root))
        }
    }
}
