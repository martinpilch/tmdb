import Quick
import Nimble
import Alamofire

@testable import tmdb

class PopularViewControllerSpec: QuickSpec {

    override func spec() {

        let expectedViewModels = PopularMovieRoot.fixture().results
        var viewController: PopularViewController!
        var navigationController: UINavigationController!

        describe("PopularViewController") {

            beforeEach {
                let session = SessionManager.makeValidSessionManager()
                let service = TmdbPopularService(endpoint: "https://www.example.com", apiKey: "foo", sessionManager: session)
                let controller = PopularController(service: service, reachableManager: MockInternetReachableManager())

                viewController = PopularViewController(controller: controller)
                navigationController = UINavigationController(rootViewController: viewController)
                navigationController.loadViewIfNeeded()
            }

            context("on viewDidLoad") {

                it("loads valid data") {
                    viewController.viewDidLoad()
                    expect(viewController.handler.viewModels).toEventually(equal(expectedViewModels))
                }
            }

            context("on filtering") {

                it("sets correct viewModels") {
                    // First "fetch" data
                    viewController.viewDidLoad()
                    expect(viewController.handler.viewModels).toEventually(equal(expectedViewModels))
                    // Then filter
                    viewController.searchController.searchBar.text = "cu"
                    viewController.updateSearchResults(for: viewController.searchController)
                    expect(viewController.handler.viewModels).toEventually(equal(PopularMovieRoot.fixtureFiltered().results))
                }
            }

            context("on movie view controller presentation") {

                it("presents MovieViewController") {
                    let movieToPresent = PopularMovieRoot.fixture().results[0]
                    viewController.handler(PopularTableViewHandler(), didSelect: movieToPresent)
                    expect((navigationController.visibleViewController as? MovieViewController)).toNotEventually(beNil())
                }
            }
        }
    }
}
