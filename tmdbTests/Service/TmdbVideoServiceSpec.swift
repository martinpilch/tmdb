import Quick
import Nimble
import Alamofire

@testable import tmdb

class TmdbVideoServiceSpec: QuickSpec {
    override func spec() {

        var sessionManager: SessionManager!
        var service: TmdbVideoService!

        describe("TmdbVideoService") {

            context("initialization") {

                beforeEach {
                    service = TmdbVideoService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720)
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
                        service = TmdbVideoService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .failure(let error):
                                    expect(error) == ServiceError.jsonDecodingError
                                default:
                                    fail("Expected TmdbVideoService to fail but got \(result)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("on empty data") {

                    beforeEach {
                        sessionManager = SessionManager.makeEmptyJsonSessionManager()
                        service = TmdbVideoService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .failure(let error):
                                    expect(error) == ServiceError.noDataError
                                default:
                                    fail("Expected TmdbVideoService to fail but got \(result)")
                                }
                                done()
                            }
                        }
                    }
                }

                context("on valid data") {

                    beforeEach {
                        sessionManager = SessionManager.makeValidSessionManager()
                        service = TmdbVideoService(endpoint: "https://www.example.com", apiKey: "foo", movieId: 374720, sessionManager: sessionManager)
                    }

                    it("calls callback with failure") {

                        waitUntil { done in
                            service.perform { result in
                                switch result {
                                case .success(let video):
                                    expect(video) == Video.fixture()
                                default:
                                    fail("Expected TmdbVideoService to fail but got \(result)")
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
