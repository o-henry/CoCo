//
//  FetchNearbyFeeds+Service.swift
//  CoCoTests
//
//  Created by Henry on 7/5/25.
//

import CoreLocation
import Foundation
import MemberwiseInit

// MARK: - 3. 서비스레이어 구현 (어플리케이션)

// SUT
@MemberwiseInit(.public)
class FetchNearbyFeedsService: FetchNearbyFeedsUseCase {
    @Init(.public) let locationProvider: UserLocationProvider
    @Init(.public) let feedRepository: FeedRepository

//    init(locationProvider: UserLocationProvider, feedRepository: FeedRepository) {
//        self.locationProvider = locationProvider
//        self.feedRepository = feedRepository
//    }

    // MARK: - 서비스레이어의 역할

    /**
     서비스 레이어는 이 아키텍처의 핵심부(Core)에서 실질적인 조율자(Orchestrator) 역할을 수행합니다. 외부의 요청을 받아 애플리케이션의 핵심 비즈니스 로직을 실행하고, 그 결과를 다시 외부로 전달하는 모든 과정을 지휘합니다.
     서비스 레이어의 핵심 역할
     1. 유스케이스(Use Case)의 구현체
     서비스 레이어의 가장 중요한 역할은 애플리케이션의 기능, 즉 유스케이스를 실제로 구현하는 것입니다. 사용자가 원하는 특정 작업을 완료하기 위한 절차와 흐름을 코드로 정의합니다.
     예시: 사용자의 다이어그램에 있는 FetchNearbyFeedsService는 '사용자 주변의 피드를 가져온다'는 하나의 유스케이스를 책임지는 서비스입니다. 마찬가지로 PublishFeedService는 '새로운 피드를 발행한다'는 유스케이스를 담당합니다.
     2. 핵심 로직과 외부 세계의 중재자
     서비스 레이어는 순수한 비즈니스 규칙을 담고 있는 도메인(Domain) 계층과 외부 기술을 다루는 어댑터(Adapter) 계층 사이의 다리 역할을 합니다.
     조율과 위임: 서비스는 직접 복잡한 비즈니스 규칙을 계산하거나 데이터베이스에 직접 접근하지 않습니다. 대신, 도메인 객체에게 비즈니스 규칙 실행을 위임하고, 포트(Port)를 통해 외부 시스템(DB, API 등)과의 통신을 요청합니다.
     의존성 역전: 서비스는 구체적인 기술(Adapter)에 직접 의존하는 대신, 추상화된 인터페이스(Port)에만 의존합니다. 이로 인해 데이터베이스가 Firebase에서 다른 것으로 바뀌어도 서비스 코드는 전혀 영향을 받지 않습니다.

     3. 포트(Port)와의 관계
     서비스 레이어는 '인커밍 포트(Incoming Port)'와 '아웃고잉 포트(Outgoing Port)' 모두와 상호작용하며 아키텍처의 중심을 잡습니다.
     인커밍 포트 (Driving Port) 구현: 외부(예: UI, 컨트롤러)의 요청을 받아들이는 창구인 인커밍 포트의 실제 구현체가 바로 서비스입니다. FetchNearbyFeedsPort.In 이라는 인터페이스가 있다면, FetchNearbyFeedsService 클래스가 이 인터페이스를 구현합니다.
     아웃고잉 포트 (Driven Port) 사용: 서비스가 외부 시스템의 기능을 필요로 할 때(예: 데이터 저장, 위치 정보 획득), 아웃고잉 포트 인터페이스를 호출합니다. 서비스는 FeedRepository라는 포트(인터페이스)를 사용할 뿐, 그 뒤에 실제 FirebaseFeedRepository 어댑터가 어떻게 동작하는지는 알지 못합니다.
     4. 워크플로우 오케스트레이션
     하나의 유스케이스를 완료하기 위해 여러 단계를 조율하고 전체적인 작업 흐름을 관리합니다.
     '주변 피드 검색' 워크플로우 예시
     요청 수신: 외부 Controller Adapter로부터 인커밍 포트를 통해 '피드 검색' 요청을 받습니다.
     데이터 조회 요청: UserLocationProvider 포트를 호출하여 현재 사용자 위치를 가져옵니다.
     데이터 조회 요청 (계속): FeedRepository 포트를 호출하여 위에서 얻은 위치를 기준으로 후보 피드 목록을 데이터베이스에서 가져오도록 요청합니다.
     비즈니스 로직 실행: 가져온 피드 목록을 대상으로, 특정 반경 내에 있는 피드만 걸러내는 비즈니스 로직을 직접 수행하거나 도메인 객체에 위임합니다.
     결과 반환: 최종 필터링된 피드 목록을 다시 인커밍 포트를 통해 Controller Adapter로 반환합니다.
     결론적으로, 서비스 레이어는 애플리케이션의 핵심 로직을 외부 환경의 변화로부터 보호하고, 독립적으로 테스트할 수 있도록 보장하는 중추적인 역할을 담당합니다. 외부의 요청을 받아 내부의 도메인 로직과 외부 인프라를 적절히 조율하여 응집도 높고 유연한 소프트웨어를 만드는 데 핵심적인 기여를 합니다
     */
    func execute(around location: CLLocation?) async throws (FetchFeedsError) -> [Feed] {
        /// 사용자 현재 위치 요청 (앱)
        ///
        ///
        return []
    }
}
