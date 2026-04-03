//
//  MapPresenter.swift
//  NatifeTask1
//
//  Created by Nazar on 29.03.2026.
//

import CoreLocation

@MainActor
protocol MapPresenterProtocol: AnyObject {
    func startInitialLoading()
    func didTapGeoButton()
    func didTapListButton()
}

final class MapPresenter: NSObject {
    
    // MARK: - Properties

    private weak var viewController: MapViewControllerProtocol?
    private var placeResults: [PlaceInfo] = []
    private let placeService: PlacesServiceProtocol
    private let locationManager = CLLocationManager()
    
    // MARK: - Initializers

    init(
        viewController: MapViewControllerProtocol,
        placeService: PlacesServiceProtocol
    ) {
        self.viewController = viewController
        self.placeService = placeService
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - Private Methods

private extension MapPresenter {
    func handleLocationAuthorization(onAuthorized: () -> Void) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            onAuthorized()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            viewController?.showLocationDeniedAlert()
        @unknown default:
            break
        }
    }

    func loadPlaces(coordinate: CLLocationCoordinate2D) async {
        do {
            let places = try await placeService.fetchNearbyPlaces(to: coordinate)
            placeResults = places
            viewController?.render(places: places)
            viewController?.setListButtonEnabled(true)
        } catch {
            placeResults = []
            viewController?.render(places: [])
            viewController?.setListButtonEnabled(false)
            if case let PlacesServiceError.loadFailed(error) = error {
                print(error.localizedDescription)
            }
            viewController?.showPlacesLoadErrorAlert(error)
        }
    }
}

// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
    func startInitialLoading() {
        handleLocationAuthorization {
            locationManager.startUpdatingLocation()
        }
    }

    func didTapGeoButton() {
        handleLocationAuthorization {
            viewController?.centerMapOnUserLocation()
        }
    }

    func didTapListButton() {
        guard !placeResults.isEmpty else { return }
        viewController?.showPlacesList(with: placeResults)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapPresenter: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            viewController?.showLocationDeniedAlert()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        manager.stopUpdatingLocation()
        viewController?.centerMap(on: coordinate)
        Task {
            await loadPlaces(coordinate: coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        viewController?.showLocationErrorAlert()
    }
}
