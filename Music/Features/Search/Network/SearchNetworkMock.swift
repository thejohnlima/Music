//
//  SearchNetworkMock.swift
//  Music
//
//  Created by John Lima on 4/25/26.
//

import Foundation

final class SearchNetworkMock: SearchNetwork {
    // MARK: - Overrides
    override func search(text: String) async -> [SearchItem] {
        if let data = fetchLocal(fileName: "search_response"),
           let response = try? JSONDecoder().decode(SearchResponse.self, from: data) {
            return response.results ?? []
        }
        return []
    }

    override func fetchAlbum(id: Int64) async -> [SearchItem] {
        if let data = fetchLocal(fileName: "album"),
           let response = try? JSONDecoder().decode(SearchResponse.self, from: data) {
            return response.results ?? []
        }
        return []
    }

    // MARK: - Private Methods
    private func fetchLocal(fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return data
        }
        return nil
    }
}
