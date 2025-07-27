//
//  User.swift
//  CoCo
//
//  Created by Henry on 7/18/25.
//

import Foundation

struct User: Identifiable {
    let id: String
    let name: String

    // MARK: - feeds: [Feed]? 를 정의하지 않는 이유

    // 직접 참조를 피함으로써 도메인간의 결합을 방지하기 위해
    // 해당 기능은 UseCase에서 동적으로 로드
}
