import UIKit

protocol PopularTableViewHandlerDelegate: class {
    func handler(_ handler: PopularTableViewHandler, didSelect movie: PopularMovie)
}

// Handler just takes viewmodels and populates and handles tableview
class PopularTableViewHandler: NSObject {
    private(set) var viewModels: [PopularMovie] = []

    weak var delegate: PopularTableViewHandlerDelegate?

    func reload(tableView: UITableView, with viewModels: [PopularMovie]) {
        self.viewModels = viewModels

        if shouldConfigure(tableView: tableView) {
            configure(tableView: tableView)
        }

        tableView.reloadData()
    }

    private func shouldConfigure(tableView: UITableView) -> Bool {
        // If either the `dataSource` or `delegate` is `nil` or not `self` then the table view hasn't
        // been configured yet.
        return (tableView.dataSource as? PopularTableViewHandler) != self ||
            (tableView.delegate as? PopularTableViewHandler) != self
    }

    private func configure(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(PopularTableViewCell.self)
    }
}

extension PopularTableViewHandler: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PopularTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        if let movie = viewModels.element(atIndex: indexPath.row) {
            cell.configure(movie)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if let selectedMovie = viewModels.element(atIndex: indexPath.row) {
            delegate?.handler(self, didSelect: selectedMovie)
        }

    }
}

