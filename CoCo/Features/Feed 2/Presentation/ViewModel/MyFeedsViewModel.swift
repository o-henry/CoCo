//
//  MyFeedsViewModel.swift
//  CoCo
//
//  Created by Henry on 7/18/25.
//

import Foundation
import Core

@available(iOS 14.0, *)
public final class MyFeedsViewModel: ObservableObject {
    @Published var feeds: [Feed] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchMyFeedsUseCase: FetchMyFeedsUseCase
    private let currentUserId: String // 예: Auth로부터 주입

    public init(fetchMyFeedsUseCase: FetchMyFeedsUseCase, currentUserId: String) {
        self.fetchMyFeedsUseCase = fetchMyFeedsUseCase
        self.currentUserId = currentUserId
    }

    @MainActor
    func loadMyFeeds() async {
        isLoading = true
        defer { isLoading = false }

        // MARK: - ViewModel이 UI 상태를 관리하니, 에러를 @Published로 노출.

        do {
            feeds = try await fetchMyFeedsUseCase.execute(forUserId: currentUserId)
        } catch let error as DomainError {
            errorMessage = error.userFriendlyMessage // 도메인 에러를 UI 메시지로 변환
        } catch {
            errorMessage = "알 수 없는 오류 발생" // 기타 에러
        }
    }
}
