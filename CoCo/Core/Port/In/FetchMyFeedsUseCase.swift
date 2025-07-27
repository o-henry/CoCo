//
//  FetchMyFeedsUseCase.swift
//  CoCo
//
//  Created by Henry on 7/18/25.
//

import Foundation

// API
public protocol FetchMyFeedsUseCase {
    @available(iOS 14.0, *)
    func execute(forUserId: String) async throws -> [Feed]
}
