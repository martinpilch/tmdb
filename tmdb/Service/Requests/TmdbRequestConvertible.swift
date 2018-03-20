import Alamofire

// Protocol to simplify request creation
protocol TmdbRequestConvertible: URLRequestConvertible {
    // We need endpoint, apiKey and path to create URL
    var endpoint: String { get }
    var apiKey: String { get }
    var path: String { get }

    // We need HTTP method as well
    var method: HTTPMethod { get }

    // Some aditional parameters if needed
    var parameters: Parameters? { get }
}

extension URLEncoding {
    // Helper function to include api key into URLparameters
    func encode(_ request: URLRequestConvertible, with parameters: Parameters?, apiKey: String) throws -> URLRequest {
        var finalParams: Parameters = ["api_key": apiKey]
        parameters?.forEach { (key, value) in
            finalParams[key] = value
        }
        return try encode(request, with: finalParams)
    }
}

extension TmdbRequestConvertible {
    // Extension to return URL request
    func asURLRequest() throws -> URLRequest {
        let url = try endpoint.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters, apiKey: apiKey)

        return urlRequest
    }
}
