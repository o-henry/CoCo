//
//  HomeScreen+View.swift
//  CoCo
//
//  Created by Henry on 7/9/25.
//

import SwiftUI
import MapKit

// MARK: - Domain to View Conversion

extension Coordinate {
    /// 도메인 모델인 `Coordinate`를 MapKit에서 사용하는 `CLLocationCoordinate2D`로 변환합니다.
    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct HomeScreen: View {
    @State private var viewModel: HomeScreenViewModel

    init(viewModel: HomeScreenViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            MapView()
            FeedListBottomSheet()
        }
        .environmentObject(viewModel)
        .task {
            await viewModel.loadNearbyFeeds()
        }
    }
}

// TODO: - MapView, FeedListBottomSheet 분리
struct MapView: View {
    @EnvironmentObject var viewModel: HomeScreenViewModel

    var body: some View {
        Map(coordinateRegion: .constant(viewModel.mapRegion)) {
            ForEach(viewModel.feeds) { feed in
                MapAnnotation(coordinate: feed.location.asCLLocationCoordinate2D) {
                    FeedMarker(
                        feed: feed,
                        isSelected: feed.id == viewModel.selectedFeed?.id
                    )
                    .onTapGesture {
                        viewModel.selectFeedFromMap(feed)
                    }
                }
            }
        }
    }
}

struct FeedListBottomSheet: View {
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