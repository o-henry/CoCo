//
//  FetchNearbyFeedsService.swift
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

    // MARK: - 서비스레이어의 역할

    func execute() async throws -> [Feed] {
        do {
            // 1. 위치 정보 가져오기
            let currentLocation = try await locationProvider.getCurrentLocation()

            // 2. 가져온 위치를 기반으로 Repository에 피드 요청
            // 반경(radius) 값은 서비스 정책에 따라 결정 (예: 2km)
            let feeds = try await feedRepository.fetchFeeds(near: currentLocation, within: 2000)

            // 3. (필요 시) 비즈니스 로직 추가
            // 예: 가져온 피드를 거리순으로 정렬하거나, 특정 조건으로 필터링

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
