//
//  SplashScreenView.swift
//  Music
//
//  Created by John Lima on 4/22/26.
//

import SwiftUI

struct SplashScreenView: View {

    // MARK: - Properties
    var body: some View {
        Image("Splash")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

// MARK: - Preview
#Preview {
    SplashScreenView()
}
