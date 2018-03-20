import Foundation

// Simple extension to work with array safely
extension Array {
    func element(atIndex index: Int) -> Element? {
        guard index >= 0 else { return .none }
        guard endIndex > index else { return .none }

        return self[index]
    }

    @discardableResult mutating func removeSafely(at index: Int) -> Element? {
        guard index >= 0 else { return .none }
        guard endIndex > index else { return .none }
        return self.remove(at: index)
    }

    mutating func insertSafely(_ newElement: Element, at i: Int) {
        guard i >= 0 else { return }
        guard endIndex >= i else { return }
        self.insert(newElement, at: i)
    }
}

