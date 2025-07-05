//
//  FetchNearbyFeeds+Service.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation
import MemberwiseInit

// MARK: - 3. 서비스레이어 구현 (어플리케이션)

// SUT
@MemberwiseInit(.public)
class FetchNearbyFeedsService: FetchNearbyFeedsUseCase {
    @Init(.public) let locationProvider: UserLocationProvider
    @Init(.public) let feedRepository: FeedRepository

//    init(locationProvider: UserLocationProvider, feedRepository: FeedRepository) {
//        self.locationProvider = locationProvider
//        self.feedRepository = feedRepository
//    }

    func execute(around location: CLLocation?) async throws (FetchFeedsError) -> [Feed] {
        /// 사용자 현재 위치 요청 (앱)
        ///
        return []
    }
}
