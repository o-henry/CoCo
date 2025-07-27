//
//  LocationProvider.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation
import MemberwiseInit

// MARK: - 2. 프로토콜 구현 (포트 구현)

protocol LocationProvider {
    func getCurrentLocation() async throws -> CLLocation
}

enum LocationError: Error {
    case authorizationDenied
    case locationUnavailable
    case unknown
}
