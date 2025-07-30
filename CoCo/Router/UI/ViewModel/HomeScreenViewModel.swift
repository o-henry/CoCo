//
//  HomeScreenViewModel
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import Factory
import Foundation
import MapKit

@Observable
class HomeScreenViewModel {
    private(set) var feeds: [Feed] = []
    private(set) var selectedFeed: Feed?
    private(set) var mapRegion: MKCoordinateRegion = .init(.world)
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    private(set) var radiusInMeters: Double = 2000

    @Injected(\.fetchNearbyFeedsUseCase) private var fetchNearbyFeedsUseCase: FetchNearbyFeedsUseCase

    // 이 메서드는 UI 상태를 변경하므로 @MainActor에서 실행되어야 합니다.
    @MainActor
    func loadNearbyFeeds() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let loadedFeeds = try await fetchNearbyFeedsUseCase.execute(radiusInMeters: radiusInMeters)
            // UI 업데이트는 메인 스레드에서 수행합니다.
            feeds = loadedFeeds
        } catch let error as FetchFeedsError {
            switch error {
            case .locationError:
                errorMessage = "위치 정보를 가져오는데 실패했습니다."
            case .repositoryError:
                errorMessage = "피드를 가져오는 중 오류가 발생했습니다. 다시 시도해주세요."
            case .unknown:
                errorMessage = "알 수 없는 오류가 발생했습니다."
            }
        } catch {
            errorMessage = "An unexpected error occurred."
        }
    }

    @MainActor
    func selectFeed(_ feed: Feed) {
        selectedFeed = feed
        updateMapRegion(to: feed.location)
    }

    @MainActor
    func selectFeedFromMap(_ feed: Feed) {
        selectedFeed = feed
    }

    @MainActor
    private func updateMapRegion(to location: Coordinate) {
        mapRegion = MKCoordinateRegion(
            center: .init(latitude: location.latitude, longitude: location.longitude),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
}
