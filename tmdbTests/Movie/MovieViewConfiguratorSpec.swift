import Quick
import Nimble
import Alamofire

@testable import tmdb

class MovieViewConfiguratorSpec: QuickSpec {

    override func spec() {

        var viewController: MovieViewController!
        var state: Loadable<Movie>!

        describe("MovieViewConfigurator") {

            beforeEach {
                let session = SessionManager.makeValidSessionManager()
                let service = TmdbMovieService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: session)
                let videoService = TmdbVideoService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: session)
                let controller = MovieController(service: service, videoService: videoService, reachableManager: MockInternetReachableManager())

                viewController = MovieViewController(controller: controller)
                viewController.loadViewIfNeeded()
            }

            describe("initializing the view") {

                beforeEach {
                    MovieViewConfigurator.initialize(viewController)
                }

                it("sets loading view style") {
                    expect(viewController.loadingView.activityIndicatorViewStyle) == UIActivityIndicatorViewStyle.gray
                }

                it("sets tableView to be hidden") {
                    expect(viewController.tableView.isHidden) == true
                }

                it("sets loadingView to be hidden") {
                    expect(viewController.loadingView.isHidden) == true
                }

                it("sets errorLabel to be hidden") {
                    expect(viewController.errorLabel.isHidden) == true
                }
            }

            describe("updating the view") {

                context("when the state is loading") {
                    beforeEach {
                        state = .loading
                        MovieViewConfigurator.configure(viewController, with: state)
                    }

                    it("shows loadingView") {
                        expect(viewController.loadingView.isHidden) == false
                    }

                    it("hides tableView") {
                        expect(viewController.tableView.isHidden) == true
                    }

                    it("hides errorLabel") {
                        expect(viewController.errorLabel.isHidden) == true
                    }
                }

                context("when the state is failed") {
                    beforeEach {
                        state = .failure(ServiceError.noDataError)
                        MovieViewConfigurator.configure(viewController, with: state)
                    }

                    it("hides loadingView") {
                        expect(viewController.loadingView.isHidden) == true
                    }

                    it("hides tableView") {
                        expect(viewController.tableView.isHidden) == true
                    }

                    it("shows errorLabel") {
                        expect(viewController.errorLabel.isHidden) == false
                    }

                    it("sets the error label text") {
                        let expectedText = NSLocalizedString("An error occured when connecting to server...", comment: "")
                        expect(viewController.errorLabel.text) == expectedText
                    }
                }

                context("when the state is loaded with some items") {
                    beforeEach {
                        state = .success(Movie.fixture())
                        MovieViewConfigurator.configure(viewController, with: state)
                    }

                    it("hides loadingView") {
                        expect(viewController.loadingView.isHidden) == true
                    }

                    it("shows tableView") {
                        expect(viewController.tableView.isHidden) == false
                    }

                    it("hides errorLabel") {
                        expect(viewController.errorLabel.isHidden) == true
                    }
                }
            }
        }
    }
}
