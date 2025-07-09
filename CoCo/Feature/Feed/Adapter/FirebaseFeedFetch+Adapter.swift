//
//  FirebaseFeedFetch+Adapter.swift
//  CoCo
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation

// 구현체
class FirebaseFeedFetchAdapter: FeedRepository {
    // private let db: Firestore // 실제 프로젝트에서는 Firestore 인스턴스를 주입받습니다.
    private let feedsCollection: String

    init(collectionName: String = "feeds") {
        self.feedsCollection = collectionName
    }

    /// 이 메서드는 외부 시스템(Firebase)과 통신하는 Adapter의 역할을 보여줍니다.
    /// 실제 구현에서는 Firestore와 GeoFire/GeoQueries를 사용하여 특정 위치 주변의 피드를 쿼리합니다.
    ///
    /// - Parameters:
    ///   - location: 피드를 검색할 중심 위치입니다.
    ///   - radius: 검색할 반경(미터 단위)입니다.
    /// - Returns: 검색된 피드 배열을 반환합니다. 실패 시 에러를 던집니다.
    func fetchFeeds(near location: CLLocation, within radius: Double = 2000.0) async throws -> [Feed] {
        // 실제로는 이 부분에서 Firebase에 비동기 쿼리를 보냅니다.
        // 예: let query = db.collection(feedsCollection).near(location, radius: radius)
        //     let documents = try await query.getDocuments()
        //     return documents.compactMap { try? $0.data(as: Feed.self) }

        print("FirebaseAdapter: Fetching feeds near (\(location.coordinate.latitude), \(location.coordinate.longitude)) within \(radius)m.")

        // 포트폴리오용 샘플이므로, 더미 데이터를 반환합니다.
        // 실제 앱의 복잡한 로직 대신 아키텍처를 보여주는 데 집중합니다.
        return [
            Feed(content: "Firebase에서 가져온 첫 번째 피드", location: Coordinate(latitude: 37.5665, longitude: 126.9780)),
            Feed(content: "Firebase에서 가져온 두 번째 피드", location: Coordinate(latitude: 37.5650, longitude: 126.9765))
        ]
    }
}
