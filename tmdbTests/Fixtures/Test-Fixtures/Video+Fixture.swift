import Foundation

@testable import tmdb

extension Video {

    static func fixture() -> Video {
        let file = Bundle(for: DummyToGetBundle.self).path(forResource: "validVideoResponse", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: file))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        let responseObject = try! decoder.decode(VideoRoot.self, from: data)
        return responseObject.results.first!
    }
}

