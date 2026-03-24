//
//  PlaceInfo.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import CoreLocation

struct PlaceInfo {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let country: String?
    let city: String?
    let address: String?
    
    var detailsText: String? {
           let value = [country, city]
               .compactMap { $0 }
               .joined(separator: ", ")
           return value.isEmpty ? nil : value
       }
}

