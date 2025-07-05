//
//  Feed.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

// MARK: - 1. 도메인 식별 / 구현

import CoreLocation
import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
struct Feed: Equatable, Identifiable {
    let id: UUID = .init()
    @Init(.public) let content: String
    @Init(.public) let location: CLLocation
}
