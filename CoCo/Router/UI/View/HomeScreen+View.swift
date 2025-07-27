//
//  HomeScreenView
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import Factory
import MapKit
import SwiftUI

// MARK: - Domain to View Conversion

struct HomeScreen: View {
    @StateObject var viewModel: HomeScreenViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            MapView()
            FeedListBottomSheetView()
        }
        .environmentObject(viewModel)
        .task {
            await viewModel.loadNearbyFeeds()
        }
    }
}
