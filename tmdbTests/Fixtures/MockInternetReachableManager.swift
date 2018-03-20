import Foundation
@testable import tmdb

class MockInternetReachableManager: InternetReachable {
    var whenReachable: InternetReachableCallback?
    var whenUnreachable: InternetReachableCallback?

    var isListening: Bool = false

    private var mockIsReachable = true
    var isReachable: Bool {
        return mockIsReachable
    }

    func startListener() {
        isListening = true
    }

    func stopListener() {
        isListening = false
    }

    // MARK: Mock functions

    func mockReachable() {
        mockIsReachable = true
        whenReachable?()
    }

    func mockUnreachable() {
        mockIsReachable = false
        whenUnreachable?()
    }
}
