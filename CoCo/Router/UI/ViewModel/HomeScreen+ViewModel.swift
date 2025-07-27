//
//  HomeScreen+ViewModel.swift
//  CoCo
//
//  Created by Henry on 7/6/25.
//

import Foundation
import MapKit

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
            feeds = try await fetchNearbyFeedsUseCase.execute()
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

    private func updateMapRegion(to location: Coordinate) {
        mapRegion = MKCoordinateRegion(
            center: .init(latitude: location.latitude, longitude: location.longitude),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
}
