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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some View {
        if isActive {
            SearchView()
                .modelContainer(sharedModelContainer)
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
