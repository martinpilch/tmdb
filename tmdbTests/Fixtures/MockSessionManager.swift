import Foundation
import Alamofire

@testable import tmdb

extension SessionManager {
    static func makeValidSessionManager() -> SessionManager {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockingURLProtocol.self]
            return configuration
        }()
        return SessionManager(configuration: configuration)
    }

    static func makeInvalidJsonSessionManager() -> SessionManager {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [InvalidJsonMockingURLProtocol.self]
            return configuration
        }()
        return SessionManager(configuration: configuration)
    }

    static func makeEmptyJsonSessionManager() -> SessionManager {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [EmptyJsonMockingURLProtocol.self]
            return configuration
        }()
        return SessionManager(configuration: configuration)
    }
}
