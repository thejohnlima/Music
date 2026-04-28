//
//  PlayerView.swift
//  Music
//
//  Created by John Lima on 4/25/26.
//

import Kingfisher
import SwiftUI

struct PlayerView: View {

    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    imageView(geometry: geometry)
                    Spacer()
                    infoControlsView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .navigationTitle(viewModel.currentMedia?.albumTitle ?? "")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {

                        } label: {
                            Label("Play", systemImage: "ellipsis")
                        }
                    }

                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("Play", systemImage: "chevron.backward")
                        }
                    }
                }
            }
        }
        .onAppear {
            guard let media = viewModel.currentMedia else { return }
            viewModel.load(media)
        }
    }

    // MARK: - Private Methods
    private func imageView(geometry: GeometryProxy) -> some View {
        let imageSize = geometry.size.width * 0.7

        return KFImage(URL(string: viewModel.currentMedia?.image ?? ""))
            .resizable()
            .placeholder { _ in
                Rectangle()
                    .foregroundStyle(.quinary)
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: imageSize, height: imageSize)
            .clipShape(.rect(cornerRadius: imageSize * 0.15))
    }

    private func infoControlsView() -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.currentMedia?.artistName ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(viewModel.currentMedia?.trackName ?? "")
                        .font(.default)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary.opacity(0.7))
                }
                .textSelection(.enabled)

                Spacer()

                Button {

                } label: {
                    Image(systemName: "repeat")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 24, height: 24)
                .foregroundStyle(.primary)
            }

            sliderView()

            HStack(spacing: 24) {
                Button {
                    viewModel.seek(to: -5)
                } label: {
                    Image(systemName: "backward.end.alt.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 28, height: 16)

                Button {
                    viewModel.togglePlayback()
                } label: {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(24)
                        .frame(width: 72, height: 72)
                        .glassEffect()
                }

                Button {
                    viewModel.seek(to: 5)
                } label: {
                    Image(systemName: "forward.end.alt.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 28, height: 16)
            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    private func sliderView() -> some View {
        let sliderBinding = Binding(
            get: {
                viewModel.isSeeking ? viewModel.dragProgress : viewModel.progress
            },
            set: { newValue in
                viewModel.updateDragProgress(newValue)
            }
        )

        return VStack {
            Slider(value: sliderBinding) { editing in
                if !editing {
                    viewModel.endSeeking()
                }
            }
            .tint(.primary)

            HStack {
                Text(viewModel.formatTime(viewModel.displayCurrentTime))
                Spacer()
                Text("-\(viewModel.formatTime(viewModel.displayRemainingTime))")
            }
            .font(.subheadline)
            .foregroundStyle(.primary.opacity(0.6))
        }
        .padding(.top)
    }
}

// MARK: - Preview
#Preview {
    PlayerView(viewModel: .mock)
}
