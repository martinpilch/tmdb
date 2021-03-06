import Foundation

@testable import tmdb

extension Movie {

    static func fixture() -> Movie {
        let file = Bundle(for: DummyToGetBundle.self).path(forResource: "validMovieResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: file))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        let responseObject = try! decoder.decode(Movie.self, from: data)
        return responseObject
    }
}
