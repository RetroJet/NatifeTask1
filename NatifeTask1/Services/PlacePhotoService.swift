//
//  PlacePhotoService.swift
//  NatifeTask1
//
//  Created by Nazar on 26.03.2026.
//

import UIKit
import GooglePlacesSwift

protocol PlacePhotoServiceProtocol {
    func fetchPhoto(from photo: Photo, maxSize: CGSize) async -> UIImage?
}

final class PlacePhotoService: PlacePhotoServiceProtocol {
    func fetchPhoto(from photo: Photo, maxSize: CGSize) async -> UIImage? {
        let request = FetchPhotoRequest(
            photo: photo,
            maxSize: maxSize
        )

        switch await PlacesClient.shared.fetchPhoto(with: request) {
        case .success(let image):
            return image
        case .failure:
            return nil
        }
    }
}
