//
//  PlayerViewModel.swift
//  Music
//
//  Created by John Lima on 4/26/26.
//

import AVFoundation
import Combine
import Foundation

final class PlayerViewModel: ObservableObject {

    // MARK: - Properties
    @Published var currentMedia: Media?
    @Published var currentTime: TimeInterval = 0
    @Published var totalDuration: TimeInterval = 0
    @Published var isPlaying = false
    @Published var isSeeking = false
    @Published var dragProgress: Double = 0

    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var endObserver: Any?

    static var mock: PlayerViewModel {
        let media = Media(
            albumTitle: "21",
            image: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/eb/ca/25/ebca2596-cd1e-b295-91a3-771c868d0a79/191404113868.png/512x512bb.jpg",
            artistName: "Adele",
            trackName: "Set Fire to the Rain"
        )

        return PlayerViewModel(item: media)
    }

    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return currentTime / totalDuration
    }

    var displayCurrentTime: TimeInterval {
        isSeeking ? dragProgress * totalDuration : currentTime
    }

    var displayRemainingTime: TimeInterval {
        max(totalDuration - displayCurrentTime, 0)
    }

    // MARK: - Initializers
    init(item: Media) {
        self.currentMedia = item
    }

    deinit {
        removeObservers()
    }

    // MARK: - Public Methods
    func load(_ media: Media) {
        currentMedia = media
        currentTime = 0
        dragProgress = 0
        isPlaying = false
        isSeeking = false

        removeObservers()

        guard let previewURLString = media.previewURL, let url = URL(string: previewURLString) else { return }

        let playerItem = AVPlayerItem(url: url)

        player = AVPlayer(playerItem: playerItem)

        Task {
            do {
                let duration = try await playerItem.asset.load(.duration)
                let actualDuration = duration.seconds

                if actualDuration.isFinite && actualDuration > 0 {
                    await MainActor.run {
                        self.totalDuration = actualDuration
                        self.togglePlayback()
                    }
                }
            } catch {
                print("❌ Failed to load asset duration: \(error)")
            }
        }

        addPeriodicTimeObserver()
        addPlaybackEndObserver()
    }

    func togglePlayback() {
        guard let player else { return }

        if isPlaying {
            player.pause()
        } else {
            if currentTime >= totalDuration, totalDuration > 0 {
                player.seek(to: .zero)
                currentTime = 0
                dragProgress = 0
            }

            player.play()
        }

        isPlaying.toggle()
    }

    func seek(to progress: Double) {
        guard totalDuration > 0 else { return }

        let newTime = progress * totalDuration
        let cmTime = CMTime(seconds: newTime, preferredTimescale: 600)

        player?.seek(to: cmTime)

        currentTime = newTime
        dragProgress = progress
    }

    func updateDragProgress(_ value: Double) {
        isSeeking = true
        dragProgress = value
    }

    func endSeeking() {
        seek(to: dragProgress)
        isSeeking = false
    }

    func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Private Methods
    private func addPeriodicTimeObserver() {
        guard let player else { return }

        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self, !self.isSeeking else { return }

            self.currentTime = time.seconds

            if self.totalDuration > 0 {
                self.dragProgress = self.currentTime / self.totalDuration
            }
        }
    }

    private func addPlaybackEndObserver() {
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }

            self.isPlaying = false
            self.currentTime = 0
            self.dragProgress = 0
            self.player?.seek(to: .zero)
            self.player?.play()
            isPlaying = true
        }
    }

    private func removeObservers() {
        if let timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }

        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
            self.endObserver = nil
        }
    }
}
