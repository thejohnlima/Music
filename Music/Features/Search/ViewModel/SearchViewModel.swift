//
//  SearchViewModel.swift
//  Music
//
//  Created by John Lima on 4/25/26.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {

    // MARK: - Properties
    @Published var items: [SearchItem] = []
    @Published var searchText = ""
    @Published var runSearch = ""
    @Published var showKeyboard = false

    private let network: SearchNetwork

    var selectedItem: SearchItem?

    static var mock: Self {
        let viewModel = Self(network: SearchNetworkMock())
        return viewModel
    }

    // MARK: - Initializers
    init(network: SearchNetwork = SearchNetwork()) {
        self.network = network
    }

    // MARK: - Public Methods
    func search(text: String) async {
        items = await network.search(text: text)
    }
}
