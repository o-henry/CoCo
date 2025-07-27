
//
//  Coordinate.swift
//  CoCo
//
//  Created by Henry on 7/9/25.
//

import Foundation
import MemberwiseInit

// Value-Object
@MemberwiseInit(.public)
public struct Coordinate: Hashable, Equatable {
    @Init(.public) let latitude: Double
    @Init(.public) let longitude: Double
}
