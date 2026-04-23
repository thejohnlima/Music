//
//  SearchView.swift
//  Music
//
//  Created by John Lima on 4/22/26.
//

import SwiftUI
import SwiftData

struct SearchView: View {

    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
            }
            .navigationTitle("Songs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: startSearch) {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
            }
        }
    }

    // MARK: - Private Methods
    private func startSearch() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
}

// MARK: - Preview
#Preview {
    SearchView()
        .modelContainer(for: Item.self, inMemory: true)
}
