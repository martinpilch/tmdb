import Quick
import Nimble
import Alamofire
import XCDYouTubeKit

@testable import tmdb

class MovieViewControllerSpec: QuickSpec {

    override func spec() {

        let expectedViewModel = Movie.fixture()
        var viewController: MovieViewController!
        var window: UIWindow!

        describe("MovieViewController") {

            beforeEach {
                let session = SessionManager.makeValidSessionManager()
                let service = TmdbMovieService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: session)
                let videoService = TmdbVideoService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: session)
                let controller = MovieController(service: service, videoService: videoService, reachableManager: MockInternetReachableManager())

                viewController = MovieViewController(controller: controller)
                viewController.loadViewIfNeeded()

                window = UIWindow()
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            }

            context("on viewDidLoad") {

                it("loads valid data") {
                    viewController.viewDidLoad()
                    expect(viewController.handler.movie).toEventually(equal(expectedViewModel))
                }
            }

            context("on trailer presentation") {

                it("presents XCDYouTubeVideoPlayerViewController") {
                    let trailerToPresent = Video.fixture()
                    viewController.handler(MovieTableViewHandler(), watchTrailerVideo: trailerToPresent)
                    expect((viewController.presentedViewController as? XCDYouTubeVideoPlayerViewController)).toNotEventually(beNil())
                }
            }
        }
    }
}
