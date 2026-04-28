//
//  SearchItem.swift
//  Music
//
//  Created by John Lima on 4/22/26.
//

import Foundation

struct SearchItem: Codable, Identifiable, Hashable {
    var id = UUID()
    var trackId: Int?
    var artistName: String?
    var trackName: String?
    var albumTitle: String?
    var artworkURL: String?
    var previewURL: String?

    var toMedia: Media {
        Media(
            trackID: trackId,
            albumTitle: albumTitle,
            image: getImageURL()?.absoluteString,
            artistName: artistName,
            trackName: trackName,
            previewURL: previewURL
        )
    }

    enum CodingKeys: String, CodingKey {
        case trackId, artistName, trackName
        case albumTitle = "collectionName"
        case artworkURL = "artworkUrl100"
        case previewURL = "previewUrl"
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
