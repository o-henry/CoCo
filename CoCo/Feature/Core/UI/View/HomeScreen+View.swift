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
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // 지도 뷰 - 부모 ViewModel 참조
            MapView(
                feeds: viewModel.feeds,
                selectedFeed: viewModel.selectedFeed,
                region: viewModel.mapRegion,
                onFeedSelected: viewModel.selectFeedFromMap
            )

            // 바텀시트 - 부모 ViewModel 참조
            FeedListBottomSheet(
                feeds: viewModel.feeds,
                selectedFeed: viewModel.selectedFeed,
                onFeedSelected: viewModel.selectFeed
            )
        }
        .task {
            await viewModel.loadNearbyFeeds()
        }
    }
}

struct MapView: View {
    let feeds: [Feed]
    let selectedFeed: Feed?
    let region: MKCoordinateRegion
    let onFeedSelected: (Feed) -> Void

    var body: some View {
        Map(coordinateRegion: .constant(region)) {
            ForEach(feeds) { feed in
                MapAnnotation(coordinate: feed.location.asCLLocationCoordinate2D) {
                    FeedMarker(
                        feed: feed,
                        isSelected: feed.id == selectedFeed?.id
                    )
                    .onTapGesture {
                        onFeedSelected(feed)
                    }
                }
            }
        }
    }
}

struct FeedListBottomSheet: View {
    let feeds: [Feed]
    let selectedFeed: Feed?
    let onFeedSelected: (Feed) -> Void

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(feeds) { feed in
                    FeedRow(
                        feed: feed,
                        isSelected: feed.id == selectedFeed?.id
                    )
                    .onTapGesture {
                        onFeedSelected(feed)
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
    }
}



