
//
//  CoreLocationAdapter.swift
//  CoCo
//
//  Created by Henry on 7/26/25.
//

import CoreLocation
import Foundation

final class CoreLocationAdapter: NSObject, LocationProvider {
    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                continuation.resume(throwing: LocationError.authorizationDenied)
                self.continuation = nil
            @unknown default:
                continuation.resume(throwing: LocationError.unknown)
                self.continuation = nil
            }
        }
    }
}

extension CoreLocationAdapter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            continuation?.resume(throwing: LocationError.locationUnavailable)
            continuation = nil
            return
        }
        continuation?.resume(returning: location)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: LocationError.locationUnavailable)
        continuation = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            continuation?.resume(throwing: LocationError.authorizationDenied)
            continuation = nil
        default:
            break
        }
    }
}
