import Quick
import Nimble
import Alamofire

@testable import tmdb

class TmdbMovieServiceSpec: QuickSpec {
    override func spec() {

        var sessionManager: SessionManager!
        var service: TmdbMovieService!

        describe("TmdbMovieService") {

            context("initialization") {

                beforeEach {
                    service = TmdbMovieService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720)
                }

                it("sets endpoint correctly") {
                    expect(service.endpoint) == "https://www.example.com"
                }

                it("sets api key correctly") {
                    expect(service.apiKey) == "foo"
                }

                it("sets movieId correctly") {
                    expect(service.movieId) == 374720
                }
            }

            context("performing request") {

                context("on invalid data") {

                    beforeEach {
                        sessionManager = SessionManager.makeInvalidJsonSessionManager()
                        service = TmdbMovieService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .failure(let error):
                                    expect(error) == ServiceError.jsonDecodingError
                                default:
                                    fail("Expected TmdbMovieService to fail but got \(result)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("on empty data") {

                    beforeEach {
                        sessionManager = SessionManager.makeEmptyJsonSessionManager()
                        service = TmdbMovieService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .failure(let error):
                                    expect(error) == ServiceError.noDataError
                                default:
                                    fail("Expected TmdbMovieService to fail but got \(result)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("on valid data") {

                    beforeEach {
                        sessionManager = SessionManager.makeValidSessionManager()
                        service = TmdbMovieService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .success(let root):
                                    expect(root) == Movie.fixture()
                                default:
                                    fail("Expected TmdbMovieService to fail but got \(result)")
                                }
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
