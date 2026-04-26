//
//  RootView.swift
//  Music
//
//  Created by John Lima on 4/22/26.
//

import SwiftData
import SwiftUI

struct RootView: View {

    // MARK: - Properties
    @State private var isActive = false

    var body: some View {
        if isActive {
            SearchView()
        } else {
            SplashScreenView()
                .onAppear {
                    Task {
                        try await Task.sleep(for: .seconds(1))

                        withAnimation {
                            isActive = true
                        }
                    }
                }
        }
    }
}

// MARK: - Preview
#Preview {
    RootView()
}
