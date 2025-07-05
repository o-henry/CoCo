//
//  CoCoTests.swift
//  CoCoTests
//
//  Created by Henry on 6/30/25.
//

@testable import CoCo
import CoreLocation
import Testing

/// 비즈니스 로직을 테스트 합니다.
@Suite("FetchNearbyFeeds - 주변 피드 검색 테스트")
struct FetchNearbyFeedsTests {
    // MARK: - Factory

    private func makeSUT() -> (
        sut: FetchNearbyFeedsService,
        locationProvider: MockUserLocationProvider,
        feedRepository: MockFeedRepository
    ) {
        let mockLocationProvider = MockUserLocationProvider()
        let mockFeedRepository = MockFeedRepository()
        let sut = FetchNearbyFeedsService(
            locationProvider: mockLocationProvider,
            feedRepository: mockFeedRepository
        )
        return (sut, mockLocationProvider, mockFeedRepository)
    }

    // MARK: - Improved Test

    @Test("주어진 반경 내의 피드만 필터링하여 반환해야 합니다")
    func fetchNearbyFeeds_whenMultipleFeedsExist_shouldReturnOnlyFeedsWithinRadius() async throws {
        // GIVEN: 테스트 준비
        let (sut, _, mockFeedRepository) = makeSUT()

        // 1. 기준 위치와 검색 반경 설정 (예: 강남역 반경 1km)
        let centerLocation = CLLocation(latitude: 37.4979, longitude: 127.0276) // 강남역
        let searchRadius: CLLocationDistance = 1000 // 1km

        // 2. Mock 데이터 설정: 반경 내/외 피드들을 모두 포함
        let feedInsideRadius = Feed(content: "강남역 근처", location: CLLocation(latitude: 37.4999, longitude: 127.0286)) // 약 230m 거리
        let feedOnEdgeOfRadius = Feed(content: "반경 경계", location: CLLocation(latitude: 37.5069, longitude: 127.0279)) // 약 1km 거리
        let feedOutsideRadius = Feed(content: "역삼역 너머", location: CLLocation(latitude: 37.5008, longitude: 127.0368)) // 약 1.6km 거리

        let allCandidateFeeds = [feedInsideRadius, feedOnEdgeOfRadius, feedOutsideRadius]
        mockFeedRepository.mockFeeds = allCandidateFeeds

        // 3. 예상 결과 정의: 반경 내의 피드만 포함
        let expectedFeeds = [feedInsideRadius, feedOnEdgeOfRadius]

        // WHEN: 테스트 대상 실행
        let resultFeeds = try await sut.execute(around: centerLocation)

        // THEN: 결과 검증
        #expect(resultFeeds.count == 2, "결과 피드는 2개여야 합니다.")

        // 결과 목록에 예상된 피드들이 모두 포함되어 있는지 확인
        // (Feed가 Hashable을 준수해야 Set으로 변환 가능)
        #expect(Set(resultFeeds) == Set(expectedFeeds), "반경 내의 피드만 포함해야 합니다.")
    }

    /// 발생 가능한 에러
    /// - 네트워크 에러
    /// - 위치정보 없음
    @Test("위치 제공자에서 에러가 발생하면, 해당 에러를 전파합니다")
    func fetchNearbyFeeds_whenLocationProviderFails_shouldThrowError() async {
        // ARRANGE
        let (sut, mockLocationProvider, _) = makeSUT()
        enum LocationError: Error { case failedToFetch }
        mockLocationProvider.mockError = LocationError.failedToFetch

        // ACT & ASSERT
        await #expect(throws: (any Error).self) {
            _ = try await sut.execute(around: nil)
        }
    }
}
