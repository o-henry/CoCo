//
//  MyFeedsViewModel
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import Core
import Factory
import Foundation

final class MyFeedsViewModel: ObservableObject {
    @Published @MainActor var feeds: [Feed] = []
    @Published @MainActor var isLoading: Bool = false
    @Published @MainActor var errorMessage: String?

    @Injected(\.fetchMyFeedsUseCase) private var fetchMyFeedsUseCase: FetchMyFeedsUseCase

    @MainActor
    func loadMyFeeds() async {
        isLoading = true
        errorMessage = nil // 초기화
        defer { isLoading = false }

        do {
            // AuthService에서 사용자 ID를 가져옵니다.
            // let userId = authService.currentUserId
            // UseCase 호출은 백그라운드에서 실행될 수 있습니다.
            let loadedFeeds = try await fetchMyFeedsUseCase.execute(userId: "blahblah")
            // UI 업데이트는 메인 스레드에서 수행합니다.
            feeds = loadedFeeds
        } catch let error as FetchMyFeedsError {
            switch error {
            case .noFeedsFound:
                errorMessage = "작성한 피드가 없습니다."
            case .networkFailure:
                errorMessage = "네트워크 오류가 발생했습니다."
            case .unknown:
                errorMessage = "알 수 없는 오류가 발생했습니다."
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
        }
    }
}
