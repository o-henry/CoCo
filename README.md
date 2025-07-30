<div align="center">
 <h1>coco</h1>
</div>

## 개요

사용자가 현재 위치를 기반으로 소식을 공유하고, 질문과 답변을 주고받을 수 있는 SwiftUI 기반 iOS 애플리케이션 입니다. 사용자는 2km 이내의 피드를 확인하고, 특정 장소를 태그하여 게시물을 작성하며, 이를 지도에서 시각적으로 확인할 수 있습니다. 이 앱은 지역 커뮤니티와의 상호작용을 강화하며, 직관적이고 매끄러운 사용자 경험을 제공하는 것을 목표로 합니다.

---

## 주요 기능 식별

* **위치 기반 피드**: 사용자의 현재 위치에서 2km 이내의 게시물을 실시간으로 검색하고 표시.
* **지도 통합**: 사용자가 선택한 위치를 지도에 마커로 표시하여 시각적 상호작용 제공.
- **회원가입 및 인증**: Apple ID를 통한 OAuth 기반 로그인으로 사용자 인증 구현.
- **미디어 지원**: 이미지 업로드(압축), 신고, 차단, 댓글 기능 구현

---

## 기술 스택

 * **Firebase**
	 - 실시간 데이터베이스
	 - 인증
	 - GeoHash를 활용한 위치기반 쿼리
	 - 초기 제공 무료
 - **MapKit**
	 - 무료 
	 - 일본 서비스에 적합
 - **Factory**
	 - 의존성 관리

---

## 프로젝트 구조

```swift
├── CoCo
│   ├── CoCoApp.swift
│   ├── ContentView.swift
│   ├── Core
│   │   └── Domain
│   │       ├── Feed.swift
│   │       └── User.swift
│   ├── DI
│   │   └── Container+Injection.swift
│   ├── Features
│   │   └── Feed
│   │       ├── Adapter
│   │       │   └── Out
│   │       │       ├── CoreLocationAdapter.swift
│   │       │       └── FirebaseFeedFetchAdapter.swift
│   │       ├── Application
│   │       │   ├── Port
│   │       │   │   ├── In
│   │       │   │   │   ├── FetchMyFeedsUseCase.swift
│   │       │   │   │   └── FetchNearbyFeedsUseCase.swift
│   │       │   │   └── Out
│   │       │   │       ├── FeedRepository.swift
│   │       │   │       └── LocationProvider.swift
│   │       │   └── Service
│   │       │       ├── FetchMyFeedsService.swift
│   │       │       └── FetchNearbyFeedsService.swift
│   │       └── Presentation
│   │           ├── View
│   │           │   └── MyFeedsView.swift
│   │           └── ViewModel
│   │               └── MyFeedsViewModel.swift
│   └── Router
│       └── UI
│           ├── View
│           │   ├── FeedListBottomSheetView.swift
│           │   ├── HomeScreenView.swift
│           │   └── MapView.swift
│           └── ViewModel
│               └── HomeScreenViewModel.swift
├── CoCoTests
│   ├── CoCoTests.swift
│   ├── EX.swift
│   ├── Mocks
│   │   └── FetchNearbyFeeds+Mocks.swift
│   └── SUT.swift
├── CoCoUITests
│   ├── CoCoUITests.swift
│   └── CoCoUITestsLaunchTests.swift
└── README.md
```


---

## 1. 아키텍처 선택

![[스크린샷 2025-07-29 오후 1.20.24.png]]

**헥사고날 아키텍처(포트 앤 어댑터)**
* 선택이유: 앱의 기능이 파이어베이스, MapKit 등 외부 기능에 매우 의존적이기 때문에 앱의 인프라를 변경할 경우 코드 대부분을 수정해야하는 문제가 있을 수 있으므로, 좀더 유연한 아키텍처를 선택.

헥사고날 아키텍처(Ports and Adapters)를 채택하여 비즈니스 로직과 외부 의존성을 분리했습니다. 이는 특정 기술(Firebase 등)에 대한 의존성을 최소화하고, 향후 확장이나 기술 교체를 용이하게 합니다. 주요 구성 요소는 다음과 같습니다:

### 도메인 레이어
- **역할**: 외부 프레임워크에 의존하지 않는 순수 비즈니스 엔티티와 로직을 포함. 
- **다이어그램 예시**: `Feed` 엔티티. 
- **특징**: 어떤 외부 계층에도 의존하지 않습니다.
### 애플리케이션 레이어
* **역할**: FetchNearbyFeedsUseCase와 같은 유스케이스와 서비스를 정의하여 비즈니스 로직을 조율.
### 인바운드 포트
- **역할**: 인터페이스(프로토콜)로 구현하며, 외부의 요청을 받아 내부의 비즈니스 로직을 실행하기 위한 부분입니다. 서비스가 구현해야할 API 명세를 정의합니다.
- **다이어그램 예시**: `FetchNearbyFeedsUseCase <<Port.In>>`
- **특징**: 코드 상에서는 ViewModel(외부요소)이 애플리케이션의 어떤 기능을 사용할 수 있는지 명시합니다. "피드를 가져온다"는 기능을 정의합니다.
### 아웃바운드 포트
- **역할**: 내부의 비즈니스 로직이 외부 시스템(DB, API 등)의 기능을 필요로 할 때 사용하는 의존성 명세입니다. "데이터를 저장해줘", "현재 위치를 알려줘"와 같은 요구사항을 인터페이스로 정의합니다.
- **다이어그램 예시**: `LocationProvider <<Port.Out>>`, `FeedRepository <<Port.Out>>
- **특징**: 서비스 계층은 이 포트(프로토콜)에만 의존합니다. 실제 구현이 Firebase인지, CoreLocation인지, 아니면 테스트용 Mock 객체인지는 전혀 알지 못합니다. 이를 통해 의존성 역전이 일어나 핵심 로직을 외부 기술로부터 보호합니다.
### 어댑터
포트라는 추상적인 약속을 **구체적인 기술을 사용해 구현**하는 구현체입니다. 외부 세계와 포트 사이에서 데이터를 변환하고 통신하는 역할을 담당합니다.
* 인바운드 어댑터
    - **역할**: 사용자의 입력이나 외부 시스템의 요청을 Inbound Port를 통해 애플리케이션 내부로 전달합니다. 즉, 애플리케이션을 **구동(Driving)**시키는 역할을 합니다.
	- **다이어그램 예시**: `FeedViewModel`, `AuthViewModel`
    - **특징**: SwiftUI의 View에서 발생한 사용자 이벤트(`UI.Event(Action)`)를 해석하여 `FetchNearbyFeedsUseCase`와 같은 Inbound Port를 호출합니다. UI 프레임워크와 애플리케이션 핵심 로직을 연결하는 역할을 합니다.
- **아웃바운드 어댑터
    - **역할**: Outbound Port 인터페이스를 실제로 구현한 클래스입니다. 애플리케이션의 요청에 따라 **구동되는(Driven)** 역할을 합니다. 외부 인프라와의 통신을 담당합니다.
    - **다이어그램 예시**: `FirebaseFeedFetchAdapter`, `CoreLocationHelper`, `CloudFunctionAdapter`
    - **특징**:
        - `FirebaseFeedFetchAdapter`는 `FeedRepository` 포트를 구현하여 실제로 Firestore SDK를 사용해 데이터를 가져옵니다. 
        - `CoreLocationHelper`는 `UserLocationProvider` 포트를 구현하여 CoreLocation 프레임워크를 통해 실제 위치 정보를 가져옵니다.
        - 만약 데이터베이스를 Firebase에서 다른 것으로 교체한다면, 서비스 로직이나 포트는 전혀 건드리지 않고 이 Outbound Adapter만 새로 만들어 교체하면 됩니다.


> 앱 개발에 적용하면서 느낀점은, 코드의 복잡도가 엄청나게 증가 한다는점 과 앱에 1:1 매칭 되지 않기때문에 타협해야할 부분이 있다는 점.

---

## 구현

비즈니스 도메인 및 유스케이스 식별

**사용자가 홈 스크린에 접근 시**,
* 사용자 현재 위치에 등록한 피드(게시글)를 확인할 수 있어야 합니다.
* 피드는 사용자의 현재 위치 기준 최대 2km이내 피드가 제공됩니다.
* 지도를 움직인뒤 해당 위치에서 요청을 하면 해당 위치 기준 2km이내의 피드들을 가져올 수 있습니다.
* 지도에 사용자 주변 피드의 위치를 표시한 마커를 표시합니다.

**사용자가 피드를 등록할 시**,
* 새로운 게시글 등록 시 데이터베이스에 저장합니다.
* 새로운 피드가 등록 되면 업데이트된 피드를 다시 불러옵니다. 해당 위치 사용자는 새로운 피드를 확인할 수 있습니다.  
  
**사용자가 댓글 등록 시**,
* 댓글을 데이터베이스에 저장합니다.

**사용자가 프로필 사진을 업데이트/수정 시,**
* 사용자가 본인 프로필 이미지를 업로드 합니다.

---

## 테스트
1. 테스트 우선순위 정하기
- **1순위: 어플리케이션 코어 (유스케이스/서비스 테스트) (단위 테스트)**
	- **대상**: `FetchNearbyFeedsService`
	- **목표**: 비즈니스 규칙을 검증합니다. (외부 시스템(실제 위치, Firebase) 없이도 서비스의 비즈니스 로직(위치 결정, 경계 계산, 데이터 호출, 중복 제거, 거리 필터링, 정렬)이 올바르게 동작하는지 완벽하게 격리하여 테스트할 수 있습니다.)
	- **방법**: 서비스가 의존하는 Port(`FeedRepository`, `UserLocationProvider`)을 Mock 객체로 대체하여 테스트합니다. 이를 통해 Firebase나 CoreLocation의 실제 동작과 무관하게 서비스의 로직만 순수하게 테스트할 수 있습니다.
	- **테스트 시나리오 예시**:
		* 시나리오 1: 모든 과정이 성공하는 'Happy Path'
		* 시나리오 2: 위치 정보를 가져오는데 실패하는 경우 
		* 시나리오 3: 리포지토리에서 피드 목록을 가져오다 실패하는 경우

---

## 에러처리

에러처리는 각 계층(Layer)의 역할에 맞게 분리해서 처리합니다. 에러처리를 위한 코드는 Port에서 관리합니다.

1. Adapter Layer
- **역할**: 외부 라이브러리/프레임워크(Firebase 등)에서 발생하는 구체적인(low-level) 오류를 감지하고, 이를 애플리케이션의 비즈니스 로직이 이해할 수 있는 일반적인(domain-agnostic) 오류 형태로 **변환하고 전파합니다.
* **대상**: `FirebaseFeedFetchAdapter`
- `FirebaseFeedFetchAdapter`에서 Firestore 통신 중 네트워크 오류가 발생하면, Firestore SDK가 던지는 `Firestore.ErrorCode`를 그대로 상위 계층으로 보내면 안 됩니다.
- 대신, `FeedRepository` 포트(Port)에 정의된 `FeedRepositoryError.networkUnavailable`과 같은 도메인 특화 오류로 변환하여 반환해야 합니다.
- **이유**: 이렇게 함으로써 애플리케이션의 핵심 로직(Use Case)이 Firebase라는 특정 기술에 종속되지 않게 됩니다. 나중에 DB를 다른 것으로 교체하더라도 Service 계층의 코드는 변경할 필요가 없어집니다.

2. Service / Use Case Layer (애플리케이션 핵심 로직)
	이 계층은 **비즈니스 관점의 오류를 처리하고 복구 전략을 결정**하는 가장 중요한 지점입니다.
	- **역할**: Adapter로부터 전달받은 도메인 오류를 바탕으로 비즈니스 규칙에 따라 다음에 어떤 행동을 할지 **결정합니다.
	- **처리 대상**: `FetchNearbyFeedsService`, `FeedPublicationService` 등
	- **구체적인 예시**:
	    - `FetchNearbyFeedsService`가 `UserLocationProvider`로부터 `.locationUnavailable` 오류를 받았습니다.
	    - 이때 서비스는 "위치 정보 없이는 주변 피드를 가져올 수 없으니, 작업을 중단하고 '위치 정보 필요' 오류를 반환한다" 와 같은 비즈니스 결정을 내립니다.
	    - 또는 "피드 목록을 가져오는 데는 성공했지만, 푸시 알림 전송에 실패했다면? 일단 피드 목록은 성공으로 처리하고, 알림 실패는 로그만 남긴다" 와 같은 복구 시나리오를 결정할 수도 있습니다.
	    - 필요하다면 재시도(Retry) 로직을 구현할 수도 있는 최적의 위치입니다.
	- **이유**: 여러 Adapter와 상호작용하며 전체 비즈니스 흐름을 관장하는 곳은 Service 계층뿐입니다. 따라서 어떤 오류가 발생했을 때 전체 작업의 성공/실패를 판단하고 그에 따른 흐름을 제어할 책임이 있습니다.

## 3. UI Layer (ViewModel)
이 계층은 처리된 오류를 **사용자에게 어떻게 보여줄지 결정**하는 최종 단계입니다.
- **역할**: Service/Use Case 계층에서 전달받은 최종 오류를 사용자 친화적인 방식으로 **표현**합니다.
- **처리 대상**: `FeedViewModel`, `AuthViewModel` 등
- **구체적인 예시**:
    - `FeedViewModel`이 `FetchNearbyFeedsUseCase`로부터 `FetchFeedsError.locationUnavailable` 오류를 받습니다.
    - ViewModel은 이 오류를 해석하여 UI 상태를 업데이트합니다. 예를 들어, `isShowingLocationErrorAlert = true` 와 같은 상태 프로퍼티를 변경합니다.
    - View는 이 상태 변화를 감지하고 사용자에게 "위치 서비스를 켜주세요" 라는 내용의 Alert을 띄워줍니다.
    - `.networkUnavailable` 오류를 받았다면 토스트 메시지를, 피드가 없다면 "주변에 피드가 없습니다" 라는 빈 화면(Empty View)을 보여주는 등 오류 종류에 따라 다른 UI를 표시하도록 결정합니다.
- **이유**: UI 계층은 비즈니스 로직을 몰라야 합니다. 오직 전달받은 상태(데이터 또는 오류)를 어떻게 시각적으로 표현할지에만 집중해야 합니다. 이를 통해 관심사를 명확히 분리할 수 있습니다.


요청하신 "피드 리스트 요청" 흐름에 맞춰 오류 처리 과정을 정리하면 다음과 같습니다.

1. **발생 및 변환 (Adapter)**: `FirestoreGeoQueryHelper`에서 네트워크 문제 발생 -> `Firestore.ErrorCode`를 `FeedRepositoryError.networkUnavailable`로 변환하여 반환합니다.
2. **결정 및 조율 (Service)**: `FetchNearbyFeedsService`가 이 오류를 받고, "네트워크 없이는 피드를 가져올 수 없다"고 판단하여 전체 유스케이스를 실패 처리하고 `FetchFeedsError.network`를 상위로 반환합니다.
3. **표현 (ViewModel)**: `FeedViewModel`이 `FetchFeedsError.network`를 받고, `showNetworkErrorToast = true` 상태를 업데이트하여 사용자에게 "네트워크 연결을 확인해주세요" 토스트 메시지를 보여줍니다.

이처럼 각 계층이 자신의 역할에 맞는 오류 처리 책임을 수행할 때, 유연하고 테스트하기 쉬우며 유지보수가 용이한 애플리케이션을 만들 수 있습니다. 현재 설계하신 아키텍처는 이러한 계층별 오류 처리를 적용하기에 매우 적합한 구조입니다.


---

## 문제 인식과 해결


**위치 문제**
	1. 한국에서 일본에 출시할 앱으로, 위치 서비스를 활용해야하는데 시뮬레이터 좌표와 gpx를 활용, 위치를 임의로 지정 함으로써 테스트


**상태 동기화 와 일관성 문제**

초기 구현시 공통 상태가 필요한 뷰를 개별 객체로 식별하여, 각 View에 1:1로 매칭되는 ViewModel을 생성했었고, 하나의 화면(부모 뷰)을 구성하는 여러 뷰가 각자의 ViewModel을 통해 동일한 인터페이스(UseCase)를 독립적으로 호출하면서 문제가 발생.

`HomeScreen`의 경우, `MapView`와 `SheetContentView`가 거의 동시에 렌더링되면서 각자의 ViewModel(`MapViewModel`, `FeedDetailViewModel`)이 `FetchNearbyFeedsUseCase`를 개별적으로 호출. 이로 인해 다음과 같은 두 가지 핵심 문제가 발생.

- **중복 호출**: 동일한 비즈니스 로직과 DB 조회가 짧은 시간 안에 중복 실행되어, 불필요한 네트워크 트래픽과 API 호출 비용을 유발.
- **데이터 불일치 위험**: 두 요청의 응답 시점에 미세한 차이가 발생할 경우, 지도에 표시되는 마커의 수와 리스트에 보이는 피드의 수가 일치하지 않는 등 데이터의 정합성이 깨질 위험이 존재.

비즈니스 로직: **사용자 현재 위치에 등록한 피드(게시글)를 확인할 수 있어야 합니다.** 를 보다 상세히 설명하면, 사용자 현재 위치 기준 2km이내의 피드를 표시하는 마커가 MapView에 보임과 동시에, BottomSheetView에 피드 리스트로 제공되어야 합니다.

이런 **양방향 상호작용이 필요한 복잡한 케이스**에서는 App+ViewModel을 통한 **중앙 집중식 상태 관리**가 가장 적합한 패턴이라고 파악함. 각 뷰는 자신의 UI에만 집중하고, 비즈니스 로직과 상태 동기화는 App+ViewModel이 담당하는 구조가 유지보수성과 확장성 측면에서 가장 효율적입니다.

두 개의 분리된 ViewModel(`MapViewModel`, `FeedViewModel`)이 동일한 데이터를 각자 관리하고 동기화하려는 현재의 접근 방식은 데이터 불일치, 불필요한 네트워크 요청, 과도하게 복잡한 양방향 통신 로직을 유발할 수 있습니다.

이 문제에 대한 가장 효과적이고 현대적인 해결책은 **'단일 진실 공급원(Single Source of Truth)'** 원칙을 적용하는 것입니다. 즉, 공유되는 모든 상태와 데이터를 하나의 상위(Parent) ViewModel이 소유하고 관리하도록 구조를 변경하는 것입니다.

**문제**: 여러 뷰(지도 뷰, 피드 뷰) 간 상태 동기화와 일관성 유지. 예를 들어, 피드 뷰에서 선택한 게시물이 지도 뷰에 즉시 반영되어야 함.

**해결책**: 상태 호이스팅 기법을 적용하여 공유 상태(selectedFeed, selectedLocation)를 상위 뷰 모델(AppViewModel)에서 중앙 관리. 이를 통해 단일 진실 공급원을 확립하고, 뷰 간 데이터 불일치를 제거했습니다. 

```swift
@Observable
class HomeScreenViewModel {
    private(set) var feeds: [Feed] = []
    private(set) var selectedFeed: Feed?
    
    func selectFeed(_ feed: Feed) {
        selectedFeed = feed
        updateMapRegion(to: feed.location)
    }
}

// HomeScreen에서 ViewModel 생성
struct HomeScreen: View {
    @State private var viewModel: HomeScreenViewModel

    init(viewModel: HomeScreenViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            MapView()
            FeedListBottomSheet()
            BottomTab()
        }
        .environmentObject(viewModel)
        .task { await viewModel.loadNearbyFeeds() }
    }
}
	
// 하위 View에서 사용
struct FeedListBottomSheet: View { 
	@EnvironmentObject var viewModel: FeedMapSharedViewModel 
	// viewModel.feeds 사용
}
```

## 접근

0. 아키텍처 선택
1. 앱 UI를 기준으로 코드에 필요한 요소들을 식별하는 과정.
2. 공통으로 사용되는 데이터 식별
