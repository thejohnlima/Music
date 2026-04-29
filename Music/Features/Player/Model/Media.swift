//
//  Media.swift
//  Music
//
//  Created by John Lima on 4/26/26.
//

import Foundation

struct Media: Hashable {
    var trackId: Int?
    var albumId: Int64?
    var albumTitle: String?
    var image: String?
    var artistName: String?
    var trackName: String?
    var previewURL: String?
}
