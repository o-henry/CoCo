//
//  MyFeedsViewModel
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import Core
import Factory
import Foundation

@Observable
class MyFeedsViewModel {
    var feeds: [Feed] = []
    var isLoading: Bool = false
    var errorMessage: String?

    @Injected(\.fetchMyFeedsUseCase) private var fetchMyFeedsUseCase: FetchMyFeedsUseCase

    @MainActor
    func loadMyFeeds() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            // AuthService에서 사용자 ID를 가져옵니다.
            // let userId = authService.currentUserId
            let loadedFeeds = try await fetchMyFeedsUseCase.execute(userId: "blahblah")
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
