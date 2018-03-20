import Alamofire

// Protocol to specify how services should look like
protocol TmdbServicable {
    // Type of returned object
    associatedtype ResultType: Equatable
    
    var endpoint: String { get }
    var apiKey: String { get }
    var sessionManager: SessionManager { get }

    // Method to call the endpoint
    func perform(onComplete: @escaping (Loadable<ResultType>) -> Void)
}
