import Foundation

// Simple enum with the most common errors
enum ServiceError: Error {
    case urlConstructionFailure
    case unreachableError
    case noDataError
    case jsonEncodingError
    case jsonDecodingError
    case unknownError

    var localizedDescription: String {
        switch self {
        case .unreachableError:
            return NSLocalizedString("Can't connect. Check your internet connection!",
                                     comment: "Error message when no internet connection")
        default:
            return NSLocalizedString("An error occured when connecting to server...",
                                     comment: "Error message when general service error occurs")
        }
    }
}

extension ServiceError: Equatable {
    public static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.urlConstructionFailure, .urlConstructionFailure),
             (.unreachableError, .unreachableError),
             (.noDataError, .noDataError),
             (.jsonEncodingError, .jsonEncodingError),
             (.jsonDecodingError, .jsonDecodingError),
             (.unknownError, .unknownError):
            return true

        // The following enumeration ensures that if we add a new case the compiler
        // will yell at us because we are not handling it.
        case (.urlConstructionFailure, _),
             (.unreachableError, _),
             (.noDataError, _),
             (.jsonEncodingError, _),
             (.jsonDecodingError, _),
             (.unknownError, _): return false
        }
    }
}
