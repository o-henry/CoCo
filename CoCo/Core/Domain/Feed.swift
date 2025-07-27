//
//  Feed.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
struct Feed: Equatable, Identifiable, Hashable {
    public let id: UUID = .init()
    @Init(.public) public let authorId: String
    @Init(.public) public let content: String
    @Init(.public) public let location: Coordinate
}

// Value-Object
@MemberwiseInit(.public)
struct Coordinate: Hashable, Equatable {
    @Init(.public) let latitude: Double
    @Init(.public) let longitude: Double
}
