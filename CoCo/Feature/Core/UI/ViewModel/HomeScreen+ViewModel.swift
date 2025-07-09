//
//  HomeScreen+ViewModel.swift
//  CoCo
//
//  Created by Henry on 7/6/25.
//

import Foundation
import MapKit

// MARK: - 부모 ViewModel에서 공유 상태 관리

@Observable
final class HomeScreenViewModel {
    // 공유 상태
    private(set) var feeds: [Feed] = []
    private(set) var selectedFeed: Feed?
    private(set) var mapRegion: MKCoordinateRegion = .default
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    // UseCase 의존성
    private let fetchNearbyFeedsUseCase: FetchNearbyFeedsUseCase
    private let userLocationProvider: UserLocationProvider

    init(
        fetchNearbyFeedsUseCase: FetchNearbyFeedsUseCase,
        userLocationProvider: UserLocationProvider
    ) {
        self.fetchNearbyFeedsUseCase = fetchNearbyFeedsUseCase
        self.userLocationProvider = userLocationProvider
    }

    // MARK: - Actions

    func loadNearbyFeeds() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            // ViewModel에서는 UseCase를 호출하는 책임만 가집니다.
            // 위치를 가져오는 구체적인 방법은 UseCase와 Service가 담당합니다.
            feeds = try await fetchNearbyFeedsUseCase.execute(around: nil)
        } catch let error as FetchFeedsError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred."
        }
    }

    func selectFeed(_ feed: Feed) {
        selectedFeed = feed
        // 지도 카메라를 선택된 피드 위치로 이동
        updateMapRegion(to: feed.location)
    }

    func selectFeedFromMap(_ feed: Feed) {
        selectedFeed = feed
        // 바텀시트가 해당 피드를 보여주도록 처리
    }

    private func updateMapRegion(to location: CLLocation) {
        mapRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
}

// MARK: - 부모 뷰

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

// MARK: - 자식 뷰들은 ViewModel 없이 상태만 받음

struct MapView: View {
    let feeds: [Feed]
    let selectedFeed: Feed?
    let region: MKCoordinateRegion
    let onFeedSelected: (Feed) -> Void

    var body: some View {
        Map(coordinateRegion: .constant(region)) {
            ForEach(feeds) { feed in
                MapAnnotation(coordinate: feed.location.coordinate) {
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
