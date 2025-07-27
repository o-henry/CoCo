
//
//  FetchMyFeedsService.swift
//  CoCo
//
//  Created by Henry on 7/18/25.
//

import Foundation
import Core

class FetchMyFeedsService: FetchMyFeedsUseCase {

    private let feedRepository: FeedRepository // Outbound Port 주입

    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }

    func execute(forUserId: String) async throws -> [Feed] {
        // 추가 비즈니스 로직 (e.g., 필터링, 캐싱 등)
        let feeds = try await feedRepository.fetchFeeds(forUserId: forUserId)

        // MARK: - 비즈니스 에러 처리/검증. Port에서 올라온 에러를 도메인 관점으로 재해석.

        // Service/UseCase 는 로직을 담당하니, "피드가 0개면 에러" 같은 규칙을 적용.

        if feeds.isEmpty {
            throw DomainError.noFeedsFound // 비즈니스 에러 발생
        }
        return feeds
    }
}
