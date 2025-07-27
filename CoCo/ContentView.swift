//
//  ContentView.swift
//  CoCo
//
//  Created by Henry on 6/30/25.
//

import Factory
import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeScreen(viewModel: Container.shared.homeScreenViewModel())
    }
}

#Preview {
    ContentView()
}
