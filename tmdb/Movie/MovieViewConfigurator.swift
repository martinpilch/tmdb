import UIKit

struct MovieViewConfigurator: ViewConfigurable {
    static func initialize(_ viewController: MovieViewController) {
        viewController.title = NSLocalizedString("Movie Detail", comment: "Title of the movie detail screen")
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

        viewController.tableView.separatorStyle = .none
        viewController.tableView.backgroundColor = .white
        viewController.tableView.isHidden = true
        viewController.tableView.rowHeight = UITableViewAutomaticDimension
        viewController.tableView.estimatedRowHeight = 200
        viewController.tableView.tableFooterView = UIView()

        // To work correctly on iPhoneX
        if #available(iOS 11.0, *) {
            viewController.tableView.insetsContentViewsToSafeArea = true
        }
    }

    static func configure(_ viewController: MovieViewController, with state: Loadable<Movie>) {
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
        case .success:
            viewController.tableView.isHidden = false
            viewController.loadingView.isHidden = true
            viewController.loadingView.stopAnimating()

            viewController.errorLabel.isHidden = true
        }
    }
}

