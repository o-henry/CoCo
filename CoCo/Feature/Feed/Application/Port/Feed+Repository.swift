//
//  Feed+Repository.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation
import MemberwiseInit

// MARK: - 2. 프로토콜 구현 (포트 구현)

protocol FeedRepository {
    // MARK: 리포지토리에서 처리하는게 맞지 않는지

    // 사용자 현재 위치기준 특정 거리의 피드를 가져오기
    func fetchFeeds(near location: CLLocation, within radius: Double) async throws -> [Feed]
}
