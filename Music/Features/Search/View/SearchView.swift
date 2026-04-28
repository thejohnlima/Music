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
        NavigationStack {
            List(viewModel.items, id: \.id) { item in
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
                    viewModel.selectedItem = item
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
                Task {
                    await viewModel.search(text: viewModel.searchText)
                }
                dismissSearch()
            }
            .fullScreenCover(item: $viewModel.selectedItem) { item in
                PlayerView(viewModel: .init(item: item.toMedia))
            }
        }
        .task {
            await viewModel.search(text: "rain")
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
