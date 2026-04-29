//
//  AlbumView.swift
//  Music
//
//  Created by John Lima on 4/28/26.
//

import Kingfisher
import SwiftUI

struct AlbumView: View {

    // MARK: - Properties
    @StateObject var viewModel: AlbumViewModel

    var body: some View {
        VStack {
            VStack {
                KFImage(viewModel.album?.getImageURL())
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .foregroundStyle(.quinary)
                    }
                    .aspectRatio(contentMode: .fill)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(width: 168, height: 168)

                VStack {
                    if let title = viewModel.album?.albumTitle {
                        Text(title)
                            .font(.headline)
                    }

                    if let title = viewModel.album?.artistName {
                        Text(title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)

                List(viewModel.tracks, id: \.id) { track in
                    HStack {
                        let imageSize = 56.0

                        KFImage(track.getImageURL(size: Int(imageSize * 3)))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(.rect(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            if let name = track.trackName {
                                Text(name)
                                    .font(.headline)
                            }

                            if let name = track.artistName {
                                Text(name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.selectedTrack = track
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            await viewModel.fetchAlbum()
        }
    }
}

// MARK: - Preview
#Preview {
    AlbumView(viewModel: .mock)
}
