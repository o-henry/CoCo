//
//  FetchNearbyFeeds+UseCase.swift
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation

protocol FetchNearbyFeedsUseCase {
    func execute(around location: CLLocation?) async throws (FetchFeedsError) -> [Feed]
}

enum FetchFeedsError: Error {
    case networkError(underlying: Error?)
    case unknown(underlying: Error?)

    var localizedDescription: String {
        switch self {
        case .networkError:
            return "ネットワークエラーが発生しました。接続状態を確認してください。"
        case .unknown:
            return "不明なエラーが発生しました。"
        }
    }
}
