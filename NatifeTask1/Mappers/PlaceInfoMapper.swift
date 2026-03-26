//
//  PlaceInfoMapper.swift
//  NatifeTask1
//
//  Created by Nazar on 20.03.2026.
//

import GooglePlacesSwift

struct PlaceInfoMapper {
    func map(_ place: GooglePlacesSwift.Place) -> PlaceInfo {
        let components = place.addressComponents
        let country = components?.first { $0.types.contains(.country) }?.name
        let city = components?.first { $0.types.contains(.locality) }?.name
        let route = components?.first { $0.types.contains(.route) }?.name
        let streetNumber = components?.first { $0.types.contains(.streetNumber) }?.name
        
        let address = [route, streetNumber]
            .compactMap { $0 }
            .joined(separator: " ")
        
        return PlaceInfo(
            name: place.displayName ?? "",
            coordinate: place.location,
            country: country,
            city: city,
            address: address.isEmpty ? nil : address,
            photo: place.photos?.first,
            rating: place.rating
        )
    }
}
