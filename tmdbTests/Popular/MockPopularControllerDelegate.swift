import Foundation

@testable import tmdb

class MockPopularControllerDelegate: PopularControllerDelegate {
    var state: Loadable<PopularMovieRoot> = .notAsked

    func update(state: Loadable<PopularMovieRoot>) {
        self.state = state
    }
}
