//
//  PlacesService.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//

import CoreLocation
import GooglePlacesSwift

protocol IPlacesService {
    func fetchNearbyPlaces(to coordinate: CLLocationCoordinate2D) async throws-> [PlaceInfo]
}

enum PlacesServiceError: LocalizedError {
    case empty
    case loadFailed
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Nothing found nearby"
        case .loadFailed:
            return "Failed to load nearby places"
        }
    }
}

final class PlacesService: IPlacesService {
    private let placesClient: PlacesClient
    private let mapper = PlaceInfoMapper()
    
    init(placesClient: PlacesClient) {
        self.placesClient = placesClient
    }
    
    func fetchNearbyPlaces(to coordinate: CLLocationCoordinate2D) async throws -> [PlaceInfo] {
        let restriction = CircularCoordinateRegion(center: coordinate, radius: 5000)
        let request = SearchNearbyRequest(
            locationRestriction: restriction,
            placeProperties: [.displayName, .coordinate, .addressComponents],
            includedTypes: [.restaurant, .cafe]
        )
        
        switch await placesClient.searchNearby(with: request) {
        case .success(let places):
            let mappedPlaces = places.map(mapper.map)
            
            if mappedPlaces.isEmpty {
                throw PlacesServiceError.empty
            }
            
            return mappedPlaces
        case .failure:
            throw PlacesServiceError.loadFailed
        }
    }
}
