import UIKit

class PopularViewController: UIViewController {
    // Properties
    let controller: PopularController
    let handler: PopularTableViewHandler
    let searchController: UISearchController

    // IB Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    @IBOutlet var errorLabelHorizontalOffsetConstraint: NSLayoutConstraint!

    // MARK: - Keyboard notifications
    private var willShowKeyboardNotification: NSObjectProtocol?
    private var willHideKeyboardNotification: NSObjectProtocol?

    init(controller: PopularController) {
        self.controller = controller
        self.handler = PopularTableViewHandler()
        self.searchController = UISearchController(searchResultsController: nil)

        super.init(nibName: String(describing: PopularViewController.self), bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        PopularViewConfigurator.initialize(self)

        handler.delegate = self

        controller.delegate = self
        controller.loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(controller:) instead")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }
}

// MARK: Search handling

extension PopularViewController {
    func isFiltering() -> Bool {
        return searchController.isActive && searchBarIsEmpty() == false
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension PopularViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        controller.filter(with: searchController.searchBar.text)
    }
}

// MARK: Controller delegate

extension PopularViewController: PopularControllerDelegate {
    func update(state: Loadable<PopularMovieRoot>) {
        // First we call configurator to set elements correctly
        PopularViewConfigurator.configure(self, with: state)

        // In case of success we reload tableview
        switch state {
        case .success(let root):
            handler.reload(tableView: tableView, with: root.results)
        default:
            break
        }
    }
}

// MARK: Handler delegate

extension PopularViewController: PopularTableViewHandlerDelegate {
    func handler(_ handler: PopularTableViewHandler, didSelect movie: PopularMovie) {
        let controller = MovieViewController.make(with: movie.id)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: Create instance

extension PopularViewController {
    static func make() -> UINavigationController {
        let service = TmdbPopularService(endpoint: AppConfiguration.movieDbEndpoint,
                                         apiKey: AppConfiguration.movieDbApiKey)
        let reachableManager = InternetReachableManager()
        let controller = PopularController(service: service, reachableManager: reachableManager)
        let popularViewController = PopularViewController(controller: controller)
        let navigationController = UINavigationController(rootViewController: popularViewController)
        return navigationController
    }
}

// MARK: - Keyboard appearance handling

extension PopularViewController {
    private func addKeyboardObservers() {

        willShowKeyboardNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { [weak self] notification in

            guard let strongSelf = self else { return }

            if let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
                let keyboardAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {

                UIView.animate(withDuration: keyboardAnimationDuration.doubleValue, animations: {
                    strongSelf.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
                    strongSelf.errorLabelHorizontalOffsetConstraint.constant = -keyboardFrame.height / 2
                    strongSelf.view.setNeedsLayout()
                })
            }
        }

        willHideKeyboardNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { [weak self] notification in
            
            guard let strongSelf = self else { return }

            if let userInfo = notification.userInfo,
                let keyboardAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {

                UIView.animate(withDuration: keyboardAnimationDuration.doubleValue, animations: {
                    strongSelf.tableView.contentInset = UIEdgeInsets.zero
                    strongSelf.errorLabelHorizontalOffsetConstraint.constant = 0.0
                    strongSelf.view.setNeedsLayout()
                })
            }
        }
    }

    private func removeKeyboardObservers() {
        if let willShowKeyboardNotification = willShowKeyboardNotification {
            NotificationCenter.default.removeObserver(willShowKeyboardNotification)
            self.willShowKeyboardNotification = nil
        }

        if let willHideKeyboardNotification = willHideKeyboardNotification {
            NotificationCenter.default.removeObserver(willHideKeyboardNotification)
            self.willHideKeyboardNotification = nil
        }
    }
}
