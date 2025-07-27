//
//  UserLocationProvider.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation
import MemberwiseInit

// MARK: - 2. 프로토콜 구현 (포트 구현)

/// 비즈니스 로직 식별
/// 사용자 현재 위치기준 2km이내의 데이터를 가져와야 합니다.
protocol UserLocationProvider {
    // 사용자 현재 위치
    func getCurrentLocation() async throws -> CLLocation
}

enum LocationError: Error {
    case authorizationDenied
    case locationUnavailable
    case unknown
}
