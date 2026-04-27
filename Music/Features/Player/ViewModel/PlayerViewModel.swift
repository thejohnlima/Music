//
//  PlayerViewModel.swift
//  Music
//
//  Created by John Lima on 4/26/26.
//

import Combine
import Foundation

final class PlayerViewModel: ObservableObject {

    // MARK: - Properties
    @Published var item: Media

    let playerService: AudioPlayerService

    static var mock: PlayerViewModel {
        let media = Media(
            albumTitle: "21",
            image: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/eb/ca/25/ebca2596-cd1e-b295-91a3-771c868d0a79/191404113868.png/512x512bb.jpg",
            artistName: "Adele",
            trackName: "Set Fire to the Rain"
        )

        return PlayerViewModel(item: media, playerService: AudioPlayerService())
    }

    var progress: Double {
        guard playerService.totalDuration > 0 else { return 0 }
        return playerService.currentTime / playerService.totalDuration
    }

    var displayCurrentTime: TimeInterval {
        playerService.isSeeking ? playerService.dragProgress * playerService.totalDuration : playerService.currentTime
    }

    var displayRemainingTime: TimeInterval {
        max(playerService.totalDuration - displayCurrentTime, 0)
    }

    var isPlaying: Bool {
        playerService.isPlaying
    }

    var isSeeking: Bool {
        playerService.isSeeking
    }

    var dragProgress: Double {
        playerService.dragProgress
    }

    // MARK: - Initializers
    init(item: Media, playerService: AudioPlayerService = .shared) {
        self.item = item
        self.playerService = playerService
        self.playerService.load(item)
    }

    // MARK: - Public Methods
    func updateDragProgress(_ value: Double) {
        playerService.isSeeking = true
        playerService.dragProgress = value
    }

    func endSeeking() {
        playerService.seek(to: playerService.dragProgress)
        playerService.isSeeking = false
    }

    func togglePlayback() {
        playerService.togglePlayback()
    }

    func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%d:%02d", minutes, seconds)
    }
}
