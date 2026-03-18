//
//  UIImageView + LoadImage.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit
import GooglePlacesSwift

extension UIImageView {
    func loadPhoto(_ photo: Photo) -> Task<Void, Never> {
        Task { @MainActor [weak self] in
            let request = FetchPhotoRequest(
                photo: photo,
                maxSize: CGSize(width: 140, height: 140)
            )

            switch await PlacesClient.shared.fetchPhoto(with: request) {
            case .success(let image):
                guard !Task.isCancelled else { return }
                self?.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

