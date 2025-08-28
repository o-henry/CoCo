//
//  FeedListBottomSheetView.swift
//  CoCo
//
//  Created by Henry on 7/27/25.
//

import Factory
import SwiftUI

struct FeedListBottomSheetView: View {
    @EnvironmentObject var viewModel: HomeScreenViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.feeds) { feed in
                    FeedRow(
                        feed: feed,
                        isSelected: feed.id == viewModel.selectedFeed?.id
                    )
                    .onTapGesture {
                        viewModel.selectFeed(feed)
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
    }
}

#Preview {
    FeedListBottomSheetView()
        .environmentObject(Container.shared.homeScreenViewModel())
}
