//
//  SongDetailsViewModel.swift
//  Music
//
//  Created by John Lima on 4/29/26.
//

import Foundation

final class SongDetailsViewModel {

    // MARK: - Properties
    private(set) var media: Media?

    static var mock: SongDetailsViewModel {
        SongDetailsViewModel(
            media: Media(
                trackId: 1544491233,
                albumId: 1544491232,
                albumTitle: "21",
                image: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/eb/ca/25/ebca2596-cd1e-b295-91a3-771c868d0a79/191404113868.png/100x100bb.jpg",
                artistName: "Adele",
                trackName: "Rolling in the Deep",
                previewURL: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/9f/07/1d/9f071dc7-791c-c869-dfa2-06b25936a287/mzaf_11077490630806345321.plus.aac.p.m4a"
            )
        )
    }

    // MARK: - Initializers
    init(media: Media) {
        self.media = media
    }
}
