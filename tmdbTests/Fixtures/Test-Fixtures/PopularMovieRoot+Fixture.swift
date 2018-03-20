import Foundation

@testable import tmdb

extension PopularMovieRoot {

    static func fixture() -> PopularMovieRoot {
        let file = Bundle(for: DummyToGetBundle.self).path(forResource: "validPopularMovieResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: file))
        let responseObject = try! JSONDecoder().decode(PopularMovieRoot.self, from: data)
        return responseObject
    }

    static func fixtureFiltered() -> PopularMovieRoot {
        let file = Bundle(for: DummyToGetBundle.self).path(forResource: "validPopularMovieFilteredResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: file))
        let responseObject = try! JSONDecoder().decode(PopularMovieRoot.self, from: data)
        return responseObject
    }

    static func fixtureEmpty() -> PopularMovieRoot {
        let responseObject = PopularMovieRoot(page: 1, results: [])
        return responseObject
    }
}

