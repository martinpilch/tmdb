import Quick
import Nimble
import Alamofire

@testable import tmdb

class TmdbPopularRequestSpec: QuickSpec {
    override func spec() {

        var request: TmdbPopularRequest!

        describe("TmdbPopularRequest") {

            beforeEach {
                request = TmdbPopularRequest(endpoint: "https://www.example.com", apiKey: "foo")
            }

            it("returns request url correctly") {
                expect(try! request.asURLRequest().url?.absoluteString) == "https://www.example.com/movie/popular?api_key=foo"
            }

            it("sets request method correctly") {
                expect(request.method) == HTTPMethod.get
            }
        }

    }
}
