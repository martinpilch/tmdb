import Foundation

@testable import tmdb

class MockMovieControllerDelegate: MovieControllerDelegate {
    var state: Loadable<Movie> = .notAsked
    var videoState: Loadable<Video> = .notAsked

    func update(state: Loadable<Movie>) {
        self.state = state
    }

    func update(videoState: Loadable<Video>) {
        self.videoState = videoState
    }
}

