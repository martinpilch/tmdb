import Foundation

// The root of the Popular movie response
struct PopularMovieRoot: Codable {
    let page: Int
    let results: [PopularMovie]

    func filter(with text: String?) -> PopularMovieRoot {
        // Fallback to return fetched results if empty string
        guard let text = text, text.isEmpty == false else {
            return self
        }

        // Filter and create new instance
        let filteredResults = results.filter { $0.title.lowercased().contains(text.lowercased()) }
        let filteredRoot = PopularMovieRoot(page: page, results: filteredResults)
        return filteredRoot
    }
}

extension PopularMovieRoot: Equatable {
    public static func == (lhs: PopularMovieRoot, rhs: PopularMovieRoot) -> Bool {
        return lhs.page == rhs.page && lhs.results == rhs.results
    }
}
