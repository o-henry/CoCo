
//
//  CoCoTests.swift
//  CoCoTests
//
//  Created by Henry on 6/30/25.
//

@testable import CoCo
import CoreLocation
import Factory
import Testing

@Suite("주변 피드 검색 기능 테스트")
struct FetchNearbyFeedsUsingFactoryTests {
    @Test("주어진 반경 내의 피드만 올바르게 반환하는지 테스트")
    func execute_whenFeedsExist_shouldReturnOnlyFeedsWithinRadius() async throws {
        // MARK: GIVEN (준비)

        // 1. 테스트 격리를 위해 Factory 컨테이너 초기화
        Container.shared.reset()

        // 2. Mock 객체 생성 및 Factory 컨테이너에 등록
        let mockLocationProvider = MockLocationProvider()
        let mockFeedRepository = MockFeedRepository()
        Container.shared.locationProvider.register { mockLocationProvider }
        Container.shared.feedRepository.register { mockFeedRepository }

        // 3. 테스트 데이터 설정
        let myLocation = CLLocation(latitude: 37.5665, longitude: 126.9780) // 서울 시청
        let searchRadius: Double = 2000

        mockLocationProvider.mockLocation = myLocation

        let feedInside = Feed(authorId: "user1", content: "시청 근처", location: .init(latitude: 37.5650, longitude: 126.9765)) // 2km 이내
        let feedAlsoInside = Feed(authorId: "user2", content: "덕수궁 돌담길", location: .init(latitude: 37.5658, longitude: 126.9751)) // 2km 이내
        let feedOutside = Feed(authorId: "user3", content: "남산타워", location: .init(latitude: 37.5512, longitude: 126.9882)) // 약 2km 바깥

        mockFeedRepository.allCandidateFeeds = [feedInside, feedAlsoInside, feedOutside]

        // 4. 테스트 대상(SUT) 생성
        let sut: FetchNearbyFeedsUseCase = Container.shared.fetchNearbyFeedsUseCase()

        // MARK: WHEN (실행)

        let resultFeeds = try await sut.execute(radiusInMeters: searchRadius)

        // MARK: THEN (검증)

        #expect(resultFeeds.count == 2, "반경 내의 피드 2개만 반환되어야 합니다.")

        let resultFeedIDs = resultFeeds.map { $0.id }
        #expect(resultFeedIDs.contains(feedInside.id), "반경 내의 첫 번째 피드가 포함되어야 합니다.")
        #expect(resultFeedIDs.contains(feedAlsoInside.id), "반경 내의 두 번째 피드가 포함되어야 합니다.")
        #expect(!resultFeedIDs.contains(feedOutside.id), "반경 밖의 피드는 포함되지 않아야 합니다.")
    }

    @Test("위치 정보 가져오기 실패 시, 올바른 에러를 던지는지 테스트")
    func execute_whenLocationFails_shouldThrowLocationError() async {
        // MARK: GIVEN

        Container.shared.reset()

        let mockLocationProvider = MockLocationProvider()
        mockLocationProvider.mockError = LocationError.authorizationDenied

        Container.shared.locationProvider.register { mockLocationProvider }
        Container.shared.feedRepository.register { MockFeedRepository() }

        let sut: FetchNearbyFeedsUseCase = Container.shared.fetchNearbyFeedsUseCase()

        // MARK: WHEN & THEN

        await #expect(throws: FetchFeedsError.self, "FetchFeedsError 타입의 에러를 던져야 합니다.") {
            _ = try await sut.execute(radiusInMeters: 2000)
        }
    }
}
