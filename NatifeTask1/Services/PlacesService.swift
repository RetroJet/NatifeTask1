//
//  PlacesService.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//

import CoreLocation
import GooglePlacesSwift

protocol PlacesServiceProtocol {
    func fetchNearbyPlaces(to coordinate: CLLocationCoordinate2D) async throws-> [PlaceInfo]
}

enum PlacesServiceError: LocalizedError {
    case empty
    case loadFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Nothing found nearby"
        case .loadFailed:
            return "Failed to load nearby places"
        }
    }
}

final class PlacesService: PlacesServiceProtocol {
    private let placesClient: PlacesClient
    private let mapper = PlaceInfoMapper()
    
    init(placesClient: PlacesClient) {
        self.placesClient = placesClient
    }
    
    func fetchNearbyPlaces(to coordinate: CLLocationCoordinate2D) async throws -> [PlaceInfo] {
        let restriction = CircularCoordinateRegion(center: coordinate, radius: Constants.searchRadius)
        let request = SearchNearbyRequest(
            locationRestriction: restriction,
            placeProperties: [.displayName, .coordinate, .addressComponents, .rating, .photos],
            includedTypes: [.restaurant, .cafe]
        )
        
        switch await placesClient.searchNearby(with: request) {
        case .success(let places):
            let mappedPlaces = places.map(mapper.map)
            
            if mappedPlaces.isEmpty {
                throw PlacesServiceError.empty
            }
            
            return mappedPlaces
        case .failure(let error):
            throw PlacesServiceError.loadFailed(error)
        }
    }
}

private extension PlacesService {
    enum Constants {
        static let searchRadius: CLLocationDistance = 5000
    }
}
