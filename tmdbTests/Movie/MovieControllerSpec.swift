import Quick
import Nimble
import Alamofire

@testable import tmdb

func makeController(with session: SessionManager,
                    delegate: MovieControllerDelegate,
                    reachableManager: MockInternetReachableManager?) -> MovieController {

    let service = TmdbMovieService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: session)
    let videoService = TmdbVideoService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: session)
    let controller = MovieController(service: service, videoService: videoService, reachableManager: reachableManager)
    controller.delegate = delegate
    return controller
}

class MovieControllerSpec: QuickSpec {
    override func spec() {

        var controller: MovieController!
        var delegate: MockMovieControllerDelegate!
        var reachableManager: MockInternetReachableManager?

        describe("MovieController") {

            context("on loadData()") {

                context("when loading valid json") {

                    let expectedResponse = Movie.fixture()

                    beforeEach {
                        delegate = MockMovieControllerDelegate()

                        let session = SessionManager.makeValidSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<Movie> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                    }

                    it("sets state to success with correct response") {
                        let expectedState: Loadable<Movie> = .success(expectedResponse)
                        expect(delegate.state).toEventually(equal(expectedState))
                        expect(controller.isLoading).toEventually(beFalse())
                    }
                }

                context("when loading invalid json") {

                    beforeEach {
                        delegate = MockMovieControllerDelegate()

                        let session = SessionManager.makeInvalidJsonSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<Movie> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                    }

                    it("sets state to failure with jsonDecodingError") {
                        let expectedState: Loadable<Movie> = .failure(.jsonDecodingError)
                        expect(delegate.state).toEventually(equal(expectedState))
                        expect(controller.isLoading).toEventually(beFalse())
                    }
                }

                context("when loading empty json") {

                    beforeEach {
                        delegate = MockMovieControllerDelegate()

                        let session = SessionManager.makeEmptyJsonSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<Movie> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                    }

                    it("sets state to failure with noDataError") {
                        let expectedState: Loadable<Movie> = .failure(.noDataError)
                        expect(delegate.state).toEventually(equal(expectedState))
                        expect(controller.isLoading).toEventually(beFalse())
                    }
                }
            }

            context("on loadVideoData()") {

                context("when loading valid json") {

                    let expectedResponse = Video.fixture()

                    beforeEach {
                        delegate = MockMovieControllerDelegate()

                        let session = SessionManager.makeValidSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadVideoData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<Video> = .loading
                        expect(delegate.videoState) == expectedState
                    }

                    it("sets state to success with correct response") {
                        let expectedState: Loadable<Video> = .success(expectedResponse)
                        expect(delegate.videoState).toEventually(equal(expectedState))
                    }
                }

                context("when loading invalid json") {

                    beforeEach {
                        delegate = MockMovieControllerDelegate()

                        let session = SessionManager.makeInvalidJsonSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadVideoData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<Video> = .loading
                        expect(delegate.videoState) == expectedState
                    }

                    it("sets state to failure with jsonDecodingError") {
                        let expectedState: Loadable<Video> = .failure(.jsonDecodingError)
                        expect(delegate.videoState).toEventually(equal(expectedState))
                    }
                }

                context("when loading empty json") {

                    beforeEach {
                        delegate = MockMovieControllerDelegate()

                        let session = SessionManager.makeEmptyJsonSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadVideoData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<Video> = .loading
                        expect(delegate.videoState) == expectedState
                    }

                    it("sets state to failure with noDataError") {
                        let expectedState: Loadable<Video> = .failure(.noDataError)
                        expect(delegate.videoState).toEventually(equal(expectedState))
                    }
                }
            }

            context("on reachability change") {

                beforeEach {
                    delegate = MockMovieControllerDelegate()
                    reachableManager = MockInternetReachableManager()

                    let session = SessionManager.makeValidSessionManager()
                    controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                }

                context("when going offline") {
                    it("sets state to error") {
                        reachableManager?.mockUnreachable()
                        let expectedState: Loadable<Movie> = .failure(.unreachableError)
                        expect(delegate.state) == expectedState
                    }
                }

                context("when going online") {
                    it("starts loading and sets state to loading") {
                        reachableManager?.mockReachable()
                        let expectedState: Loadable<Movie> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                    }
                }
            }
        }
    }
}
