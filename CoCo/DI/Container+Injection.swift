//
//  Container+Injection.swift
//  CoCo
//
//  Created by Henry on 7/25/25.
//

import CoreLocation
import Factory
import Foundation

// MARK: - App Container

extension Container {
    // MARK: - Adapters (Infrastructure Layer)

    var feedRepository: Factory<FeedRepository> {
        self { FirebaseFeedFetchAdapter() }.singleton
    }

    var locationProvider: Factory<LocationProvider> {
        self { CoreLocationAdapter() }.singleton
    }

    // MARK: - Use Cases (Application Layer)

    var fetchNearbyFeedsUseCase: Factory<FetchNearbyFeedsUseCase> {
        self { FetchNearbyFeedsService(locationProvider: self.locationProvider(), feedRepository: self.feedRepository()) }
    }

    var fetchMyFeedsUseCase: Factory<FetchMyFeedsUseCase> {
        self { FetchMyFeedsService() }
    }

    // MARK: - ViewModels (Presentation Layer)

    var homeScreenViewModel: Factory<HomeScreenViewModel> {
        self { HomeScreenViewModel() }
    }

    var myFeedsViewModel: Factory<MyFeedsViewModel> {
        self { MyFeedsViewModel() }
    }
}
