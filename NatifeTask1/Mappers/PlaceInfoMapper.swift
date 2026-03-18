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
        
        let detailsText = [country, city]
            .compactMap { $0 }
            .joined(separator: ", ")
        
        let addressText = [route, streetNumber]
            .compactMap { $0 }
            .joined(separator: " ")
        
        return PlaceInfo(
            nameText: place.displayName ?? "",
            coordinate: place.location,
            detailsText: detailsText.isEmpty ? nil: detailsText,
            addressText: addressText.isEmpty ? nil: addressText
        )
    }
}
