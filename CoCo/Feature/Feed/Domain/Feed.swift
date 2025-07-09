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
    let id: UUID = .init()
    @Init(.public) let content: String
    @Init(.public) let location: Coordinate
}
