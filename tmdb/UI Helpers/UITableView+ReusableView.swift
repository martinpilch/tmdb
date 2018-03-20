import UIKit

// Using Swift Generics to simplify cell registration
extension UITableView {

    // MARK: Table View Cell

    func register<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)

        self.register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    // MARK: Table View Header Footer View

    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)

        self.register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            return nil
        }
        return cell
    }
}
