
//
//  MyFeedsView.swift
//  CoCo
//
//  Created by Henry on 7/18/25.
//

import Core
import SwiftUI

@available(iOS 14.0, *)
public struct MyFeedsView: View {
    @ObservedObject private var viewModel: MyFeedsViewModel

    public init(viewModel: MyFeedsViewModel) {
//        _viewModel = StateObject(wrappedValue: viewModel)
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("로딩 중...")
            } else if let error = viewModel.errorMessage {
                Text("오류: \(error)").foregroundColor(.red)
            } else {
                List(viewModel.feeds) { feed in
                    Text(feed.content)
                }
            }
        }
        .task {
            await viewModel.loadMyFeeds()
        }
    }
}

#Preview {
    // Mock 의존성 주입으로 프리뷰 생성
    let mockUseCase = MockFetchMyFeedsService()
    let mockViewModel = MyFeedsViewModel(
        fetchMyFeedsUseCase: mockUseCase,
        currentUserId: "preview-user-123"
    )

    NavigationView {
        MyFeedsView(viewModel: mockViewModel)
    }
}
