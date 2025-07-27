//
//  FetchMyFeedsService
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import Factory
import Foundation

class FetchMyFeedsService: FetchMyFeedsUseCase {
    @Injected(Container.feedRepository) private var feedRepository: FeedRepository

    func execute(userId: String) async throws -> [Feed] {
        do {
            let feeds = try await feedRepository.fetchFeeds(userId: userId)

            if feeds.isEmpty {
                throw FetchMyFeedsError.noFeedsFound
            }
            return feeds

        } catch let error as FeedRepositoryError {
            throw FetchMyFeedsError.networkFailure(underlying: error)
        } catch let error as FetchMyFeedsError {
            throw error
        } catch {
            throw FetchMyFeedsError.unknown(underlying: error)
        }
    }
}
