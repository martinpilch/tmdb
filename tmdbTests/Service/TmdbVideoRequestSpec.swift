import Quick
import Nimble
import Alamofire

@testable import tmdb

class TmdbVideoRequestSpec: QuickSpec {
    override func spec() {

        var request: TmdbVideoRequest!

        describe("TmdbVideoRequest") {

            beforeEach {
                request = TmdbVideoRequest(endpoint: "https://www.example.com", apiKey: "foo", movieId: 1)
            }

            it("returns request url correctly") {
                expect(try! request.asURLRequest().url?.absoluteString) == "https://www.example.com/movie/1/videos?api_key=foo"
            }

            it("sets request method correctly") {
                expect(request.method) == HTTPMethod.get
            }
        }

    }
}
