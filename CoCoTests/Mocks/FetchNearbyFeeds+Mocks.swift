//
//  FetchNearbyFeeds+Mocks.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation

// UserLocationProvider의 Mock 구현
class MockUserLocationProvider: UserLocationProvider {
    var mockLocation: CLLocation?
    var mockError: Error?

    func getCurrentLocation() async throws -> CLLocation {
        if let error = mockError { throw error }
        guard let location = mockLocation else {
            fatalError("Mock location not set")
        }
        return location
    }
}

// FeedRepository의 Mock 구현
class MockFeedRepository: FeedRepository {
    var mockFeeds: [Feed]?
    var mockError: Error?

    func fetchFeeds(near location: CLLocation, within radius: Double) async throws -> [Feed] {
        if let error = mockError { throw error }
        return mockFeeds ?? []
    }
}
