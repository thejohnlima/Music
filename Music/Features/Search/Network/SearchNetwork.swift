//
//  SearchNetwork.swift
//  Music
//
//  Created by John Lima on 4/25/26.
//

import Foundation

class SearchNetwork {
    
    /// Fetch search results
    /// - Parameter text: Search text
    /// - Returns: Returns an async search results
    func search(text: String) async -> [SearchItem] {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(text)&entity=musicTrack") else { return [] }

        let request = URLRequest(url: url)

        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else { return [] }

        let results = response.results ?? []

        return results
    }


    /// Fetch album
    /// - Parameter id: Album ID
    /// - Returns: Returns the album and the list of tracks
    func fetchAlbum(id: Int64) async -> [SearchItem] {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(id)&entity=song") else { return [] }

        let request = URLRequest(url: url)

        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else { return [] }

        let results = response.results ?? []

        return results
    }
}
