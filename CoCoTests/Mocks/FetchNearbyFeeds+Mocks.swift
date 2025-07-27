//
//  FetchNearbyFeeds+Mocks.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

@testable import CoCo
import CoreLocation
import Foundation

class MockLocationProvider: LocationProvider {
    var mockLocation: CLLocation?
    var mockError: Error?

    func getCurrentLocation() async throws -> CLLocation {
        if let error = mockError { throw error }
        guard let location = mockLocation else { fatalError("Mock location not set") }
        return location
    }
}

// 실제처럼 거리 필터링을 수행하는 Mock Repository
class MockFeedRepository: FeedRepository {
    /// 테스트에서 설정할 모든 후보 피드 목록입니다.
    var allCandidateFeeds: [Feed] = []
    var mockError: Error?

    func fetchFeeds(near location: CLLocation, within radius: Double) async throws -> [Feed] {
        if let error = mockError {
            throw error
        }

        // 실제 코드는 GeoHash를 사용
        let filteredFeeds = allCandidateFeeds.filter { feed in
            let feedLocation = CLLocation(latitude: feed.location.latitude, longitude: feed.location.longitude)
            return location.distance(from: feedLocation) <= radius
        }
        return filteredFeeds
    }

    func fetchFeeds(userId: String) async throws -> [Feed] {
        if let error = mockError { throw error }
        return allCandidateFeeds.filter { $0.authorId == userId }
    }
}
