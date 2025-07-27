//
//  HomeScreenViewModel
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import Factory
import Foundation
import MapKit

// @MainActor 키워드를 클래스 전체에서 제거합니다.
final class HomeScreenViewModel: ObservableObject {
    // 공유 상태 - 이 프로퍼티들은 UI와 직접 연결되므로 @MainActor로 지정합니다.
    @Published @MainActor private(set) var feeds: [Feed] = []
    @Published @MainActor private(set) var selectedFeed: Feed?
    @Published @MainActor private(set) var mapRegion: MKCoordinateRegion = .default
    @Published @MainActor private(set) var isLoading: Bool = false
    @Published @MainActor private(set) var errorMessage: String?

    // @Injected를 사용하여 Container로부터 의존성을 자동으로 주입받습니다.
    @Injected(Container.fetchNearbyFeedsUseCase) private var fetchNearbyFeedsUseCase: FetchNearbyFeedsUseCase

    // MARK: - Actions

    // 이 메서드는 UI 상태를 변경하므로 @MainActor에서 실행되어야 합니다.
    @MainActor
    func loadNearbyFeeds() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            // UseCase 호출은 백그라운드에서 실행될 수 있습니다.
            let loadedFeeds = try await fetchNearbyFeedsUseCase.execute()
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

    // 이 메서드들은 UI 상태를 직접 변경하므로 @MainActor로 지정합니다.
    @MainActor
    func selectFeed(_ feed: Feed) {
        selectedFeed = feed
        // 지도 카메라를 선택된 피드 위치로 이동
        updateMapRegion(to: feed.location)
    }

    @MainActor
    func selectFeedFromMap(_ feed: Feed) {
        selectedFeed = feed
        // 바텀시트가 해당 피드를 보여주도록 처리
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
