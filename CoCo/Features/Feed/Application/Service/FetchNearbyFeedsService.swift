//
//  FetchNearbyFeedsService
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Factory
import Foundation
import MemberwiseInit

// MARK: - 3. 서비스레이어 구현 (어플리케이션)

class FetchNearbyFeedsService: FetchNearbyFeedsUseCase {
    @Injected(\.locationProvider) private var locationProvider: LocationProvider
    @Injected(\.feedRepository) private var feedRepository: FeedRepository

    // MARK: - 서비스레이어의 역할

    func execute(radiusInMeters: Double) async throws -> [Feed] {
        do {
            // 1. 위치 정보 가져오기
            let currentLocation = try await locationProvider.getCurrentLocation()

            // 2. 가져온 위치를 기반으로 Repository에 피드 요청
            let feeds = try await feedRepository.fetchFeeds(near: currentLocation, within: radiusInMeters)

            // 가져온 피드를 거리순으로 정렬하거나, 특정 조건으로 필터링

            return feeds
        } catch let error as LocationError {
            // 위치 관련 에러를 구체적인 FetchFeedsError로 변환
            throw FetchFeedsError.locationError(underlying: error)
        } catch let error as FeedRepositoryError {
            // 리포지토리 관련 에러를 구체적인 FetchFeedsError로 변환
            throw FetchFeedsError.repositoryError(underlying: error)
        } catch {
            // 예상치 못한 기타 에러 처리
            throw FetchFeedsError.unknown(underlying: error)
        }
    }
}
