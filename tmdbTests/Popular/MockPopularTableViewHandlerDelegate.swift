import Foundation

@testable import tmdb

class MockPopularTableViewHandlerDelegate: PopularTableViewHandlerDelegate {
    var selectedMovie: PopularMovie?

    func handler(_ handler: PopularTableViewHandler, didSelect movie: PopularMovie) {
        self.selectedMovie = movie
    }
}
