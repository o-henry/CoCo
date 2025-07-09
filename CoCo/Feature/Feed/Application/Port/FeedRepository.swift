//
//  Feed+Repository.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation

// MARK: - Port

/// 데이터 저장소에서 발생할 수 있는 오류를 정의합니다.
enum FeedRepositoryError: Error {
    case permissionDenied
    case network(underlying: Error)
    case unknown(underlying: Error?)
}

protocol FeedRepository {
    /// 사용자 현재 위치 기준 특정 거리의 피드를 가져옵니다.
    func fetchFeeds(near location: CLLocation, within radius: Double) async throws -> [Feed]
}
