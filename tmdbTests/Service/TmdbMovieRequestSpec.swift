import Quick
import Nimble
import Alamofire

@testable import tmdb

class TmdbMovieRequestSpec: QuickSpec {
    override func spec() {

        var request: TmdbMovieRequest!

        describe("TmdbMovieRequest") {

            beforeEach {
                request = TmdbMovieRequest(endpoint: "https://www.example.com", apiKey: "foo", movieId: 1)
            }

            it("returns request url correctly") {
                expect(try! request.asURLRequest().url?.absoluteString) == "https://www.example.com/movie/1?api_key=foo"
            }

            it("sets request method correctly") {
                expect(request.method) == HTTPMethod.get
            }
        }

    }
}
