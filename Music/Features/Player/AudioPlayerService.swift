//
//  AudioPlayerService.swift
//  Music
//
//  Created by John Lima on 4/26/26.
//

import Foundation
import AVFoundation
import Combine

final class AudioPlayerService: ObservableObject {

    // MARK: - Properties
    @Published var currentMedia: Media?
    @Published var currentTime: TimeInterval = 0
    @Published var totalDuration: TimeInterval = 0
    @Published var isPlaying = false
    @Published var isSeeking = false
    @Published var dragProgress: Double = 0

    static let shared = AudioPlayerService()

    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var endObserver: Any?

    deinit {
        removeObservers()
    }

    // MARK: - Public Methods
    func load(_ media: Media) {
        guard currentMedia?.trackID != media.trackID else { return }

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
