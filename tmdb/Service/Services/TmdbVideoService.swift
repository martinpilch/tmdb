import Alamofire

// Service to get first video fo the specified movie
class TmdbVideoService: TmdbServicable {
    typealias ResultType = Video

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
        let request = TmdbVideoRequest(endpoint: endpoint, apiKey: apiKey, movieId: movieId)
        sessionManager.request(request)
            .response { response in
                guard let data = response.data, data.count > 0 else {
                    onComplete(.failure(.noDataError))
                    return
                }

                guard let videoRoot = try? JSONDecoder().decode(VideoRoot.self, from: data) else {
                    onComplete(.failure(.jsonDecodingError))
                    return
                }

                // Select the very first video
                guard let video = videoRoot.results.element(atIndex: 0) else {
                    onComplete(.failure(.noDataError))
                    return
                }

                onComplete(.success(video))
        }
    }
}
