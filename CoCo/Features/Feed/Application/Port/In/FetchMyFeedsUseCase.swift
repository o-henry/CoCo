//
//  FetchMyFeedsUseCase.swift
//  CoCo
//
//  Created by Henry on 7/18/25.
//

import Foundation

// API
protocol FetchMyFeedsUseCase {
    func execute(userId: String) async throws -> [Feed]
}

enum FetchMyFeedsError: Error {
    case noFeedsFound
    case networkFailure(underlying: Error)
    case unknown(underlying: Error)
}
