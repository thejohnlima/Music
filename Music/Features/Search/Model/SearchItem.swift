//
//  SearchItem.swift
//  Music
//
//  Created by John Lima on 4/22/26.
//

import Foundation
import SwiftData

@Model
final class SearchItem: Codable, Identifiable {
    var id = UUID()
    var artistName: String?
    var trackName: String?
    var artworkURL: String?

    init(artistName: String, trackName: String, artworkURL: String) {
        self.artistName = artistName
        self.trackName = trackName
        self.artworkURL = artworkURL
    }

    enum CodingKeys: String, CodingKey {
        case artistName, trackName
        case artworkURL = "artworkUrl100"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try container.decode(String.self, forKey: .artistName)
        trackName = try container.decode(String.self, forKey: .trackName)
        artworkURL = try container.decode(String.self, forKey: .artworkURL)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artistName, forKey: .artistName)
        try container.encode(trackName, forKey: .trackName)
        try container.encode(artworkURL, forKey: .artworkURL)
    }

    func getImageURL(size: Int = 512) -> URL? {
        let pattern = #"/\d+x\d+"#

        guard let artworkURL else { return nil }

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return URL(string: artworkURL)
        }

        let range = NSRange(location: 0, length: artworkURL.utf16.count)
        let replacement = "/\(size)x\(size)"

        let newString = regex.stringByReplacingMatches(
            in: artworkURL,
            options: [],
            range: range,
            withTemplate: replacement
        )

        return URL(string: newString)
    }
}
