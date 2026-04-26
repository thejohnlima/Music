//
//  SearchCoordinator.swift
//  Music
//
//  Created by John Lima on 4/25/26.
//

import Combine
import SwiftUI

final class SearchCoordinator: ObservableObject {

    // MARK: - Properties
    @Published var path = NavigationPath()

    // MARK: - Public Methods
    func pushPlayer(_ item: SearchItem) {
        path.append(item)
    }
}
