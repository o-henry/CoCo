//
//  FetchNearbyFeeds+UseCase.swift
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation

protocol FetchNearbyFeedsUseCase {
    func execute() async throws -> [Feed]
}

enum FetchFeedsError: Error {
    case locationError(underlying: Error?)
    case repositoryError(underlying: Error)
    case unknown(underlying: Error?)

    var localizedDescription: String {
        switch self {
        case .locationError:
            return "위치 정보를 가져오는데 실패했습니다."
        case .repositoryError:
            return "피드를 가져오는 중 오류가 발생했습니다. 다시 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
