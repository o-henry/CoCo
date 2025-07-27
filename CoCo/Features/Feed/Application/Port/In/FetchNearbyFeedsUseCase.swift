//
//  FetchNearbyFeeds+UseCase.swift
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation

// API
protocol FetchNearbyFeedsUseCase {
    /// - Parameter radiusInMeters: 검색 반경(미터 단위).
    func execute(radiusInMeters: Double) async throws -> [Feed]
}

enum FetchFeedsError: Error {
    case locationError(underlying: Error?)
    case repositoryError(underlying: Error)
    case unknown(underlying: Error?)
}
