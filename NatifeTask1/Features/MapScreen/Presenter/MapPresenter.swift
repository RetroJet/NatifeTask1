//
//  MapPresenter.swift
//  NatifeTask1
//
//  Created by Nazar on 29.03.2026.
//

import CoreLocation

protocol MapPresenterProtocol: AnyObject {
    func loadPlaces(coordinate: CLLocationCoordinate2D) async
    func showPlacesList()
}

final class MapPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: MapViewControllerProtocol?
    private var placeResults: [PlaceInfo] = []
    private let placeService: PlacesServiceProtocol
    
    // MARK: - Initializers
    
    init(
        viewController: MapViewControllerProtocol,
        placeService: PlacesServiceProtocol
    ) {
        self.viewController = viewController
        self.placeService = placeService
    }
}

// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
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
    
    func showPlacesList() {
        guard !placeResults.isEmpty else { return }
        viewController?.showPlacesList(with: placeResults)
    }
}
