//
//  SearchNetworkMock.swift
//  Music
//
//  Created by John Lima on 4/25/26.
//

import Foundation

final class SearchNetworkMock: SearchNetwork {
    override func search(text: String) async -> [SearchItem] {
        if let path = Bundle.main.path(forResource: "search_response", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let response = try? JSONDecoder().decode(SearchResponse.self, from: data) {
            return response.results ?? []
        }
        return []
    }
}
