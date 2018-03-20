import Foundation

@testable import tmdb

class MockMovieTableViewHandlerDelegate: MovieTableViewHandlerDelegate {
    var trailerVideo: Video?

    func handler(_ handler: MovieTableViewHandler, watchTrailerVideo video: Video?) {
        self.trailerVideo = video
    }
}
