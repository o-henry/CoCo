//
//  FirebaseFeedFetch+Adapter.swift
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation
import GeoFire
import GeoFireUtils

// 구현체
class FirebaseFeedFetchAdapter: FeedRepository {
    private let db: Firestore
    private let feedsCollection: String

    init(firestore: Firestore = Firestore.firestore(), collectionName: String = "feeds") {
        self.db = firestore
        self.feedsCollection = collectionName
    }

    /// GeoQuery 부분은 Firebase 의존적인 기능
    func fetchFeeds(near location: CLLocation, within radius: Double = 2000.0) async throws -> [Feed] {
        /// Firebase DB에서 요청을 한다.
        /// 요청 시 GeoFire를 활용해서 특정 거리 이내의 피드만을 가져온다.
        /// 그러니까 구현 상세에 해당하는 요소를 아키텍처상 가장 외부로 밀고, 내부는 순수하게 유지하기
        return []
    }

//    private let db: Firestore
//     private let feedsCollection: String
//
//     init(firestore: Firestore = Firestore.firestore(), collectionName: String = "feeds") {
//         self.db = firestore
//         self.feedsCollection = collectionName
//     }
//
//     func fetchFeeds(within bounds: [GFGeoQueryBounds]) async throws -> [Feed] {
//         var candidateFeeds: [Feed] = []
//
//         let fiveDaysAgoDate = Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
//         let fiveDaysAgoTimestamp = Timestamp(date: fiveDaysAgoDate)
//
//         // Firestore 쿼리를 병렬로 실행하기 위해 TaskGroup 사용
//         try await withThrowingTaskGroup(of: [Feed].self) { group in
//             for bound in bounds {
//                 group.addTask { [weak self] in
//                     guard let self = self else { return [] } // 약한 참조 해제
//
//                     // Firestore 쿼리 생성 (geohash 기준)
//                     // 중요: Firestore 문서의 geohash 필드명이 'geohash'라고 가정
//                     let query = self.db.collection(self.feedsCollection)
//                         .order(by: "geohash") // Feed 구조체의 geohash 필드명 사용
//                         .whereField("geohash", isGreaterThanOrEqualTo: bound.startValue)
//                         .whereField("geohash", isLessThanOrEqualTo: bound.endValue)
//                         .whereField("date", isGreaterThanOrEqualTo: fiveDaysAgoTimestamp)
//
//                     do {
//                         let querySnapshot = try await query.getDocuments()
//
//                         // Firestore 문서를 Feed 객체로 디코딩
//                         // 디코딩 실패 시 해당 문서는 제외 (compactMap)
//                         let feedsInBound = querySnapshot.documents.compactMap { document -> Feed? in
//                             do {
//                                 var feed = try document.data(as: Feed.self)
//                                 // Firestore @DocumentID가 자동으로 채워지지 않는 경우 수동 설정
//                                 feed.id = document.documentID
//                                 return feed
//                             } catch let decodingError as DecodingError {
//                                 // 디코딩 오류 로깅 (어떤 문서에서 어떤 오류가 났는지 파악)
//                                 // 실패한 문서는 nil 반환하여 compactMap에서 걸러냄
//                                 return nil
//                             } catch {
//                                 return nil
//                             }
//                         }
//                         return feedsInBound
//                     } catch {
//                         // Firestore 쿼리 자체의 오류
//                         // TaskGroup 내에서 오류 발생 시 TaskGroup 전체가 취소될 수 있음
//                         throw error // 에러를 다시 던져서 TaskGroup이 처리하도록 함
//                     }
//                 }
//             }
//
//             // 각 Task의 결과(Feed 배열)를 수집
//             for try await feedsResult in group {
//                 candidateFeeds.append(contentsOf: feedsResult)
//             }
//         } // TaskGroup 종료
//
//         // TaskGroup 내에서 오류 없이 완료된 경우, 수집된 후보 피드 반환
//         // 참고: Firestore 쿼리는 동일 문서를 여러 bound에서 중복으로 가져올 수 있음
//         // 중복 제거는 필요 시 호출하는 쪽(Service)에서 수행하거나 여기서 수행 가능
//         // 여기서는 중복 포함된 상태로 반환 (거리 필터링 후 중복 제거가 효율적일 수 있음)
//         return candidateFeeds
//     }
//
//     func fetchFeeds(byAuthorId authorId: String) async throws -> [Feed] {
//         var fetchedFeeds: [Feed] = []
//
//         let query = db.collection(feedsCollection)
//             .whereField("authorId", isEqualTo: authorId) // 🟢 authorId 필드로 쿼리
//             .order(by: "date", descending: true) // 최신순 정렬
//
//         do {
//             let querySnapshot = try await query.getDocuments()
//
//             fetchedFeeds = querySnapshot.documents.compactMap { document -> Feed? in
//                 do {
//                     var feed = try document.data(as: Feed.self)
//                     feed.id = document.documentID
//                     return feed
//                 } catch let decodingError {
//                     return nil
//                 }
//             }
//         } catch {
//             throw error
//         }
//         return fetchedFeeds
//     }
    // }
}
