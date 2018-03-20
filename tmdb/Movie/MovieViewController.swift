import UIKit
import XCDYouTubeKit
import MediaPlayer

class MovieViewController: UIViewController {
    let controller: MovieController
    let handler: MovieTableViewHandler

    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    init(controller: MovieController) {
        self.controller = controller
        self.handler = MovieTableViewHandler()

        super.init(nibName: String(describing: MovieViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(controller:) instead")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        MovieViewConfigurator.initialize(self)

        handler.delegate = self

        controller.delegate = self
        controller.loadData()
        controller.loadVideoData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension MovieViewController: MovieControllerDelegate {
    func update(state: Loadable<Movie>) {
        // First we call configurator to set elements correctly
        MovieViewConfigurator.configure(self, with: state)

        // In case of success we reload tableview
        switch state {
        case .success(let movie):
            handler.reload(tableView: tableView, with: movie)
        default:
            break
        }
    }

    func update(videoState: Loadable<Video>) {
        switch videoState {
        case .loading, .notAsked:
            handler.reload(tableView: tableView, isLoadingTrailer: true, videoAvailable: false)
        case .failure:
            handler.reload(tableView: tableView, isLoadingTrailer: false, videoAvailable: false)
        case .success(let video):
            handler.reload(tableView: tableView, isLoadingTrailer: false, videoAvailable: true, trailerVideo: video)
        }
    }
}

extension MovieViewController: MovieTableViewHandlerDelegate {
    func handler(_ handler: MovieTableViewHandler, watchTrailerVideo video: Video?) {
        guard let key = video?.key else { return }

        let videoPlayerController = XCDYouTubeVideoPlayerViewController(videoIdentifier: key)
        present(videoPlayerController, animated: true, completion: nil)
    }
}

extension MovieViewController {
    // Helper func to create instance of view controller
    static func make(with movieId: Int) -> MovieViewController {
        let service = TmdbMovieService(endpoint: AppConfiguration.movieDbEndpoint,
                                       apiKey: AppConfiguration.movieDbApiKey,
                                       movieId: movieId)
        let videoService = TmdbVideoService(endpoint: AppConfiguration.movieDbEndpoint,
                                            apiKey: AppConfiguration.movieDbApiKey,
                                            movieId: movieId)
        let reachableManager = InternetReachableManager()
        let controller = MovieController(service: service, videoService: videoService, reachableManager: reachableManager)
        let movieViewController = MovieViewController(controller: controller)
        return movieViewController
    }
}
