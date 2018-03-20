import Quick
import Nimble
import Alamofire

@testable import tmdb

class TmdbPopularServiceSpec: QuickSpec {
    override func spec() {

        var sessionManager: SessionManager!
        var service: TmdbPopularService!

        describe("TmdbPopularService") {

            context("initialization") {

                beforeEach {
                    service = TmdbPopularService(endpoint: "https://www.example.com", apiKey: "foo")
                }

                it("sets endpoint correctly") {
                    expect(service.endpoint) == "https://www.example.com"
                }

                it("sets api key correctly") {
                    expect(service.apiKey) == "foo"
                }
            }

            context("performing request") {

                context("on invalid data") {

                    beforeEach {
                        sessionManager = SessionManager.makeInvalidJsonSessionManager()
                        service = TmdbPopularService(endpoint: "https://www.example.com", apiKey: "foo", sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .failure(let error):
                                    expect(error) == ServiceError.jsonDecodingError
                                default:
                                    fail("Expected TmdbPopularService to fail but got \(result)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("on empty data") {

                    beforeEach {
                        sessionManager = SessionManager.makeEmptyJsonSessionManager()
                        service = TmdbPopularService(endpoint: "https://www.example.com", apiKey: "foo", sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .failure(let error):
                                    expect(error) == ServiceError.noDataError
                                default:
                                    fail("Expected TmdbPopularService to fail but got \(result)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("on valid data") {

                    beforeEach {
                        sessionManager = SessionManager.makeValidSessionManager()
                        service = TmdbPopularService(endpoint: "https://www.example.com", apiKey: "foo", sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .success(let root):
                                    expect(root) == PopularMovieRoot.fixture()
                                default:
                                    fail("Expected TmdbPopularService to fail but got \(result)")
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
