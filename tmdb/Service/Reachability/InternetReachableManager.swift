import Foundation
import Reachability

// Reachability manager using Reachability framework to get online/offline status
class InternetReachableManager: InternetReachable {
    var whenReachable: InternetReachableCallback?
    var whenUnreachable: InternetReachableCallback?

    var isListening: Bool = false
    var isReachable: Bool {
        return reachability.connection != .none
    }

    private let reachability: Reachability

    init?() {
        guard let reachability = Reachability() else { return nil }
        
        self.reachability = reachability
        self.reachability.whenReachable = { [weak self] _ in
            self?.whenReachable?()
        }
        self.reachability.whenUnreachable = { [weak self] _ in
            self?.whenUnreachable?()
        }
    }

    func startListener() {
        do {
            try reachability.startNotifier()
            isListening = true
        } catch {
            isListening = false
        }
    }

    func stopListener() {
        reachability.stopNotifier()
        isListening = false
    }
}
