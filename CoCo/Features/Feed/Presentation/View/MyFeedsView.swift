//
//  MyFeedsView
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import Factory
import SwiftUI

struct MyFeedsView: View {
    @State var viewModel: MyFeedsViewModel

    var body: some View {
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
