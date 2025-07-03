//
//  CoCoTests.swift
//  CoCoTests
//
//  Created by Henry on 6/30/25.
//

@testable import CoCo
import Testing

@Suite("FetchNearbyFeeds - 주변 피드 검색 테스트")
struct FetchNearbyFeedsTests {
    // MARK: - Factory

    private func makeSUT() -> (
        //        sut: /**/, mock: /**/
    ) {}

    // 초기 1. RED FLAG TEST
    // USE CASE 테스트
    @Test("🟢 - 피드 리스트 가져오기")
    func fetch_nearby_feeds() async throws {
        // Feeds
        // FetchNearbyFeeds

        #expect(false)
    }
}

// MARK: - 1. 도메인 식별 / 구현

import CoreLocation
import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
struct Feed: Equatable, Identifiable {
    let id: UUID = .init()
    @Init(.public) let caption: String
}

/// USE TYPED-THROWS
protocol FetchNearbyFeedsUseCase {
    func execute(around location: CLLocation?) async throws
}


