//
//  SongDetailsView.swift
//  Music
//
//  Created by John Lima on 4/29/26.
//

import SwiftUI

struct SongDetailsView: View {

    // MARK: - Properties
    @Environment(\.dismiss) var dismiss

    let viewModel: SongDetailsViewModel
    var viewAlbum: (() -> Void)?

    var body: some View {
        VStack {
            VStack {
                if let trackName = viewModel.media?.trackName {
                    Text(trackName)
                        .font(.headline)
                }

                if let artistName = viewModel.media?.artistName {
                    Text(artistName)
                        .font(.subheadline)
                }
            }
            .padding()
            .padding(.top)

            List {
                HStack {
                    Label("View album", systemImage: "music.note.square.stack")
                }
                .listRowSeparator(.hidden)
                .foregroundStyle(.primary)
                .onTapGesture {
                    dismiss()

                    Task {
                        try await Task.sleep(for: .seconds(0.3))
                        viewAlbum?()
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Preview
#Preview {
    SongDetailsView(viewModel: .mock)
}
