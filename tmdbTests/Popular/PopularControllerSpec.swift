import Quick
import Nimble
import Alamofire

@testable import tmdb

func makeController(with session: SessionManager,
                    delegate: PopularControllerDelegate,
                    reachableManager: MockInternetReachableManager?) -> PopularController {

    let service = TmdbPopularService(endpoint: "https://www.example.com", apiKey: "foo", sessionManager: session)
    let controller = PopularController(service: service, reachableManager: reachableManager)
    controller.delegate = delegate
    return controller
}

class PopularControllerSpec: QuickSpec {
    override func spec() {

        var controller: PopularController!
        var delegate: MockPopularControllerDelegate!
        var reachableManager: MockInternetReachableManager?

        let expectedResponse = PopularMovieRoot.fixture()

        describe("PopularController") {

            context("on loadData()") {

                context("when loading valid json") {

                    beforeEach {
                        delegate = MockPopularControllerDelegate()

                        let session = SessionManager.makeValidSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<PopularMovieRoot> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                        expect(controller.result) == expectedState
                    }

                    it("sets state to success with correct response") {
                        let expectedState: Loadable<PopularMovieRoot> = .success(expectedResponse)
                        expect(delegate.state).toEventually(equal(expectedState))
                        expect(controller.isLoading).toEventually(beFalse())
                        expect(controller.result).toEventually(equal(expectedState))
                    }
                }

                context("when loading invalid json") {

                    beforeEach {
                        delegate = MockPopularControllerDelegate()

                        let session = SessionManager.makeInvalidJsonSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<PopularMovieRoot> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                        expect(controller.result) == expectedState
                    }

                    it("sets state to failure with jsonDecodingError") {
                        let expectedState: Loadable<PopularMovieRoot> = .failure(.jsonDecodingError)
                        expect(delegate.state).toEventually(equal(expectedState))
                        expect(controller.isLoading).toEventually(beFalse())
                        expect(controller.result).toEventually(equal(expectedState))
                    }
                }

                context("when loading empty json") {

                    beforeEach {
                        delegate = MockPopularControllerDelegate()

                        let session = SessionManager.makeEmptyJsonSessionManager()
                        controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                        controller.loadData()
                    }

                    it("sets state to loading first") {
                        let expectedState: Loadable<PopularMovieRoot> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                        expect(controller.result) == expectedState
                    }

                    it("sets state to failure with noDataError") {
                        let expectedState: Loadable<PopularMovieRoot> = .failure(.noDataError)
                        expect(delegate.state).toEventually(equal(expectedState))
                        expect(controller.isLoading).toEventually(beFalse())
                        expect(controller.result).toEventually(equal(expectedState))
                    }
                }
            }

            context("on reachability change") {

                beforeEach {
                    delegate = MockPopularControllerDelegate()
                    reachableManager = MockInternetReachableManager()

                    let session = SessionManager.makeValidSessionManager()
                    controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                }

                context("when going offline") {
                    it("sets state to error") {
                        reachableManager?.mockUnreachable()
                        let expectedState: Loadable<PopularMovieRoot> = .failure(.unreachableError)
                        expect(delegate.state) == expectedState
                    }
                }

                context("when going online") {
                    it("starts loading and sets state to loading") {
                        reachableManager?.mockReachable()
                        let expectedState: Loadable<PopularMovieRoot> = .loading
                        expect(delegate.state) == expectedState
                        expect(controller.isLoading) == true
                        expect(controller.result) == expectedState
                        expect(controller.result).toEventually(equal(expectedState))
                    }
                }
            }

            context("on filtering") {

                beforeEach {
                    delegate = MockPopularControllerDelegate()
                    reachableManager = MockInternetReachableManager()

                    let session = SessionManager.makeValidSessionManager()
                    controller = makeController(with: session, delegate: delegate, reachableManager: reachableManager)
                    controller.loadData()
                }

                it("returns Cult of Chucky for 'cu'") {
                    // First wait to get data loaded
                    let expectedState: Loadable<PopularMovieRoot> = .success(expectedResponse)
                    expect(delegate.state).toEventually(equal(expectedState))
                    // Then filter
                    controller.filter(with: "cu")
                    let filteredState: Loadable<PopularMovieRoot> = .success(PopularMovieRoot.fixtureFiltered())
                    expect(delegate.state).toEventually(equal(filteredState))
                }

                it("returns all items with nil text") {
                    // First wait to get data loaded
                    let expectedState: Loadable<PopularMovieRoot> = .success(expectedResponse)
                    expect(delegate.state).toEventually(equal(expectedState))
                    // Then filter
                    controller.filter(with: nil)
                    expect(delegate.state).toEventually(equal(expectedState))
                }

                it("returns all items with empty text") {
                    // First wait to get data loaded
                    let expectedState: Loadable<PopularMovieRoot> = .success(expectedResponse)
                    expect(delegate.state).toEventually(equal(expectedState))
                    // Then filter
                    controller.filter(with: "")
                    expect(delegate.state).toEventually(equal(expectedState))
                }

                it("returns zero items with non existing text") {
                    // First wait to get data loaded
                    let expectedState: Loadable<PopularMovieRoot> = .success(expectedResponse)
                    expect(delegate.state).toEventually(equal(expectedState))
                    // Then filter
                    controller.filter(with: "foobar")
                    let emptyState: Loadable<PopularMovieRoot> = .success(PopularMovieRoot.fixtureEmpty())
                    expect(delegate.state).toEventually(equal(emptyState))
                }
            }
        }
    }
}
