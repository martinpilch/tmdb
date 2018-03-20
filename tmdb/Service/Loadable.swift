import Foundation

// Enum for passing around info about request status
enum Loadable<T> where T: Equatable {
    case notAsked
    case loading
    case failure(ServiceError)
    case success(T)
}

extension Loadable: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notAsked, .notAsked):
            return true
        case (.loading, .loading):
            return true
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError == rhsError
        case (.notAsked, _), (.loading, _), (.success, _), (.failure, _):
            return false
        }
    }

    static func != (left: Loadable<T>, right: Loadable<T>) -> Bool {
        return (left == right) == false
    }
}
