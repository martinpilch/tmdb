import UIKit

// Protocol specifying how view configurator should look like
protocol ViewConfigurable {
    associatedtype ViewController
    associatedtype ResultType: Equatable

    static func initialize(_ viewController: ViewController)
    static func configure(_ viewController: ViewController, with state: Loadable<ResultType>)
}
