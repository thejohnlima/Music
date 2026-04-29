//
//  AlbumViewModel.swift
//  Music
//
//  Created by John Lima on 4/28/26.
//

import Combine
import Foundation

final class AlbumViewModel: ObservableObject {

    // MARK: - Properties
    @Published var album: SearchItem?
    @Published var tracks: [SearchItem] = []
    @Published var selectedTrack: SearchItem?

    private let albumId: Int64
    private let network: SearchNetwork

    static var mock: Self {
        Self(albumId: 1544491232, network: SearchNetworkMock())
    }

    // MARK: - Initializers
    init(albumId: Int64, network: SearchNetwork = SearchNetwork()) {
        self.albumId = albumId
        self.network = network
    }

    // MARK: - Public Methods
    func fetchAlbum() async {
        let results = await network.fetchAlbum(id: albumId)

        album = results.first { $0.type == .album }
        tracks = results.filter { $0.type == .track }
    }
}
