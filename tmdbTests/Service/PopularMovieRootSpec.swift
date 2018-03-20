import Quick
import Nimble
import Alamofire

@testable import tmdb

class PopularMovieRootSpec: QuickSpec {
    override func spec() {

        var root: PopularMovieRoot!

        describe("PopularMovieRoot") {

            beforeEach {
                root = PopularMovieRoot.fixture()
            }

            it("returns empty results for nonsense filter text") {
                expect(root.filter(with: "foobar")) == PopularMovieRoot.fixtureEmpty()
            }

            it("returns original results for empty text") {
                expect(root.filter(with: "")) == root
            }

            it("returns original results for nil text") {
                expect(root.filter(with: nil)) == root
            }

            it("returns filtered results for 'cu' text") {
                expect(root.filter(with: "cu")) == PopularMovieRoot.fixtureFiltered()
            }
        }
    }
}
