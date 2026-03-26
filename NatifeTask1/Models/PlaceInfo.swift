//
//  PlaceInfo.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import CoreLocation
import GooglePlacesSwift

struct PlaceInfo {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let country: String?
    let city: String?
    let address: String?
    let photo: Photo?
    let rating: Float?
    
    var detailsText: String? {
        let value = [country, city]
            .compactMap { $0 }
            .joined(separator: ", ")
        return value.isEmpty ? nil : value
    }
    
    var ratingText: String? {
        guard let rating else { return nil }
        let starsCount = Int(round(rating))
        let stars = String(repeating: "⭐", count: starsCount)
        return "\(String(format: "%.1f", rating)) \(stars)"
    }
}

