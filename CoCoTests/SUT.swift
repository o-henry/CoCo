//
//  SUT.swift
//  CoCoTests
//
//  Created by Henry on 7/3/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
struct Message: Equatable, Identifiable {
    let id: UUID = .init() // private(set)과 같은건지
    @Init(.public) let content: String
    let sentAt: Date = .init()

    var isValid: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
