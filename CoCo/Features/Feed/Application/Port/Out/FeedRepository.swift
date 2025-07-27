//
//  Feed+Repository.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation

enum FeedRepositoryError: Error {
    case permissionDenied
    case network(underlying: Error)
    case unknown(underlying: Error?)
}

protocol FeedRepository {
    /// 사용자 현재 위치 기준 특정 거리의 피드를 가져옵니다.
    func fetchFeeds(near location: CLLocation, within radius: Double) async throws -> [Feed]

    /// 사용자 ID 기반으로 피드 리스트를 가져옵니다.
    func fetchFeeds(userId: String) async throws -> [Feed]
}
