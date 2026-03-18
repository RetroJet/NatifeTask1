//
//  Untitled.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//
import GooglePlacesSwift
import GooglePlaces

final class NetworkManager {
    private let placesClient = PlacesClient.shared
    
    //GET Places
    func fetchNearbyPlaces(to coordinate: CLLocationCoordinate2D) async -> [PlaceInfo] {
        let restriction = CircularCoordinateRegion(center: coordinate, radius: 5000)
        let searchNearbyRequest = SearchNearbyRequest(
            locationRestriction: restriction,
            placeProperties: [ .displayName, .coordinate, .addressComponents],
            includedTypes: [ .restaurant, .cafe],
        )
        switch await placesClient.searchNearby(with: searchNearbyRequest) {
        case .success(let places):
            return places.map { place in
                let component = place.addressComponents
                let country = component?.first { $0.types.contains(.country) }?.name
                let city = component?.first { $0.types.contains(.locality) }?.name
                let route = component?.first { $0.types.contains(.route) }?.name
                let streetNumber = component?.first { $0.types.contains(.streetNumber) }?.name
                let address = [route, streetNumber].compactMap { $0 }.joined(separator: " ")
                
                return  PlaceInfo(
                    displayName: place.displayName,
                    coordinate: place.location,
                    country: country,
                    city: city,
                    address: address
                )
            }
        case .failure:
            print("Error places")
            return []
        }
    }
}
