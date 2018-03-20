typealias InternetReachableCallback = () -> ()

// Internet reachable protocol
protocol InternetReachable: class {

    var whenReachable: InternetReachableCallback? { get set }
    var whenUnreachable: InternetReachableCallback? { get set }

    var isListening: Bool { get }
    var isReachable: Bool { get }

    func startListener()
    func stopListener()
}
