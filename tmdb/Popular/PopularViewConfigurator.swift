import UIKit

// Simple class to config ciew controller UI
struct PopularViewConfigurator: ViewConfigurable {
    static func initialize(_ viewController: PopularViewController) {
        viewController.title = NSLocalizedString("Movie Catalog", comment: "Title of the main screen containing popular movies")
        viewController.view.backgroundColor = .white
        viewController.extendedLayoutIncludesOpaqueBars = true

        viewController.loadingView.backgroundColor = .clear
        viewController.loadingView.activityIndicatorViewStyle = .gray
        viewController.loadingView.isHidden = true

        viewController.errorLabel.textColor = .black
        viewController.errorLabel.font = .systemFont(ofSize: 20)
        viewController.errorLabel.lineBreakMode = .byWordWrapping
        viewController.errorLabel.numberOfLines = 0
        viewController.errorLabel.textAlignment = .center
        viewController.errorLabel.isHidden = true

        viewController.tableView.backgroundColor = .white
        viewController.tableView.isHidden = true
        viewController.tableView.rowHeight = 100
        viewController.tableView.tableFooterView = UIView()

        // To work correctly on iPhoneX
        if #available(iOS 11.0, *) {
            viewController.tableView.insetsContentViewsToSafeArea = true
        }
        
        setupSearchController(viewController)
    }

    // Setup searching
    private static func setupSearchController(_ viewController: PopularViewController) {
        viewController.searchController.searchResultsUpdater = viewController
        viewController.searchController.searchBar.placeholder = NSLocalizedString("Search Movies", comment: "Searchbar placeholder")

        // Do not obscures
        if #available(iOS 9.1, *) {
            viewController.searchController.obscuresBackgroundDuringPresentation = false
        }

        if #available(iOS 11.0, *) {
            viewController.navigationItem.searchController = viewController.searchController
            viewController.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // On older versions we display searching in tableview
            viewController.tableView.tableHeaderView = viewController.searchController.searchBar
        }
        
        viewController.definesPresentationContext = true
    }

    static func configure(_ viewController: PopularViewController, with state: Loadable<PopularMovieRoot>) {
        switch state {
        case .notAsked:
            viewController.tableView.isHidden = true
            viewController.loadingView.isHidden = true
            viewController.errorLabel.isHidden = true
        case .loading:
            viewController.tableView.isHidden = true
            viewController.loadingView.isHidden = false
            viewController.loadingView.startAnimating()
            viewController.errorLabel.isHidden = true
        case .failure(let error):
            viewController.tableView.isHidden = true
            viewController.loadingView.isHidden = true
            viewController.loadingView.stopAnimating()

            viewController.errorLabel.isHidden = false
            viewController.errorLabel.text = error.localizedDescription
        case .success(let root):
            viewController.tableView.isHidden = root.results.count == 0
            viewController.loadingView.isHidden = true
            viewController.loadingView.stopAnimating()

            viewController.errorLabel.isHidden = root.results.count > 0
            viewController.errorLabel.text = NSLocalizedString("No Movies in the catalogue",
                                                                comment: "Message when no popular movies in the catalogue")
        }
    }
}
