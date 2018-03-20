//
//  Mocks.swift
//  MockAlamofire
//
//  Created by Steigerwald, Kris S. (CONT) on 2/13/17.
//  Copyright © 2017 Velaru. All rights reserved.
//

// Updated by Martin Pilch to use files

import Foundation

enum MockMethod: String {
    case get = "GET", put = "PUT", post = "POST"

    var verb: String {
        switch self {
        case .get: return "INDEX"
        case .put: return "UPDATE"
        case .post: return "CREATE"
        }
    }

}

struct Mocks {
    private static var mocks = [
        "/movie/popular": [
            "INDEX": "validPopularMovieResponse"
        ],
        "/movie/374720": [
            "INDEX": "validMovieResponse"
        ],
        "/movie/374720/videos": [
            "INDEX": "validVideoResponse"
        ]
    ]

    private static func index(_ resource: String, verb: String) -> String? {
        guard let book = mocks[resource] else {
            print("FAILED TO FIND KEY")
            return nil
        }
        guard let verb = book[verb] else {
            print("FAILED TO FIND RESOURCE ACTION, PLEASE INCLUDE MOCK")
            return nil
        }
        return verb
    }

    static func find(_ request: URLRequest ) -> Data? {
        guard let path = (request.url?.path),
            let method = request.httpMethod,
            let direction = MockMethod(rawValue: method)
            else { return nil }

        guard let fileName = index(path, verb: direction.verb) else { return nil }
        let file = Bundle(for: DummyToGetBundle.self).path(forResource: fileName, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: file))

        return data
    }
}
