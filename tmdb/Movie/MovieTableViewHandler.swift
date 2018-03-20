import UIKit

protocol MovieTableViewHandlerDelegate: class {
    func handler(_ handler: MovieTableViewHandler, watchTrailerVideo video: Video?)
}

// Handler just takes viewmodels and populates and handles tableview
class MovieTableViewHandler: NSObject {
    private(set) var movie: Movie?
    private(set) var isLoadingTrailer: Bool = true
    private(set) var videoAvailable: Bool = false
    private(set) var trailerVideo: Video?

    weak var delegate: MovieTableViewHandlerDelegate?

    func reload(tableView: UITableView, with movie: Movie) {
        self.movie = movie

        if shouldConfigure(tableView: tableView) {
            configure(tableView: tableView)
        }

        tableView.reloadData()
    }

    func reload(tableView: UITableView, isLoadingTrailer: Bool, videoAvailable: Bool, trailerVideo: Video? = nil) {
        self.isLoadingTrailer = isLoadingTrailer
        self.videoAvailable = videoAvailable
        self.trailerVideo = trailerVideo

        // We need to finish movie loading first
        if movie != nil {
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: 0, section:0)], with: .automatic)
            tableView.endUpdates()
        }
    }

    private func shouldConfigure(tableView: UITableView) -> Bool {
        // If either the `dataSource` or `delegate` is `nil` or not `self` then the table view hasn't
        // been configured yet.
        return (tableView.dataSource as? MovieTableViewHandler) != self ||
            (tableView.delegate as? MovieTableViewHandler) != self
    }

    private func configure(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(MovieTitleTableViewCell.self)
        tableView.register(MovieInfoTableViewCell.self)
    }
}

extension MovieTableViewHandler: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            // The title cell
            let cell: MovieTitleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let movie = movie {
                cell.configure(movie)
            }

            cell.configure(isLoadingTrailer: isLoadingTrailer, videoAvailable: videoAvailable)
            cell.delegate = self

            return cell

        } else if indexPath.row == 1 {
            // The info cell
            let cell: MovieInfoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let movie = movie {
                cell.configure(movie)
            }

            return cell

        } else {
            fatalError("No cell to return in MovieTableViewHandler")
        }
    }
}

extension MovieTableViewHandler: MovieTitleTableViewCellDelegate {
    func cell(_ cell: MovieTitleTableViewCell, watchTrailerFor movie: Movie?) {
        delegate?.handler(self, watchTrailerVideo: trailerVideo)
    }
}
