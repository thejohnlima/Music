//
//  SearchView.swift
//  Music
//
//  Created by John Lima on 4/22/26.
//

import Kingfisher
import SwiftUI

struct SearchView: View {

    // MARK: - Properties
    @Environment(\.dismissSearch) private var dismissSearch
    @StateObject private var coordinator = SearchCoordinator()
    @StateObject var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            List(viewModel.items) { item in
                HStack {
                    let imageSize = 56.0

                    KFImage(item.getImageURL(size: Int(imageSize * 3)))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(.rect(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 4) {
                        if let name = item.trackName {
                            Text(name)
                                .font(.headline)
                        }

                        if let name = item.artistName {
                            Text(name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .badge(
                    Text("\(Image(systemName: "ellipsis"))")
                )
                .listRowSeparator(.hidden)
                .onTapGesture {
                    coordinator.pushPlayer(item)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Songs")
            .toolbarTitleDisplayMode(.inlineLarge)
            .scrollDismissesKeyboard(.interactively)
            .searchable(
                text: $viewModel.searchText,
                isPresented: $viewModel.showKeyboard,
                placement: .navigationBarDrawer
            )
            .onSubmit(of: .search) {
                viewModel.runSearch = viewModel.searchText
                dismissSearch()
            }
            .navigationDestination(for: SearchItem.self) { item in
                PlayerView()
            }
        }
        .task {
            await viewModel.search(text: "love")
        }
    }

    // MARK: - Private Methods
    private func startSearch() {
        viewModel.showKeyboard = true
    }
}

// MARK: - Preview
#Preview {
    SearchView(viewModel: .mock)
}
