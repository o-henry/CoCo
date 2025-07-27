//
//  FirebaseFeedFetchAdapter.swift
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

        // 샘플 이므로, 더미 데이터를 반환합니다.
        // 실제 앱의 복잡한 로직 대신 아키텍처를 보여주는 데 집중합니다.
        return [
            Feed(
                authorId: "01X2XFF",
                content: "Firebase에서 가져온 첫 번째 피드",
                location: Coordinate(latitude: 37.5665, longitude: 126.9780)
            ),
            Feed(
                authorId: "FF2G87",
                content: "Firebase에서 가져온 두 번째 피드",
                location: Coordinate(latitude: 37.5650, longitude: 126.9765)
            )
        ]
    }

    func fetchFeeds(userId: String) async throws -> [Feed] {
        /// 1. 오류 변환 (Adapter)
        /// Firestore와 같은 외부 시스템의 구체적인 오류(예: `FirebaseError`)를
        /// 애플리케이션이 이해할 수 있는 일반적인 오류(`FeedRepositoryError`)로 변환합니다.
        do {
            // 실제로는 이 부분에서 Firestore 쿼리를 실행합니다.
            // let snapshot = try await Firestore.instance.collection("feeds")...
            return [] // 성공 시 실제 데이터 반환
        } catch let error as FeedRepositoryError {
            throw error
        } catch {
            // Firestore 등 외부 라이브러리의 구체적인 오류를 비즈니스 오류로 변환합니다.
            // 여기서는 네트워크 관련 문제로 가정하고 .network 오류로 매핑합니다.
            print("FirebaseFeedFetchAdapter: Firestore 오류를 FeedRepositoryError.network로 변환합니다.")
            throw FeedRepositoryError.network(underlying: error)
        }
    }
}
