//
//  MapView.swift
//  CoCo
//
//  Created by Henry on 7/27/25.
//

import MapKit
import SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: HomeScreenViewModel

    var body: some View {
        Map(coordinateRegion: .constant(viewModel.mapRegion)) { _ in
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

extension Coordinate {
    /// 도메인 모델인 `Coordinate`를 MapKit에서 사용하는 `CLLocationCoordinate2D`로 변환합니다.
    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
