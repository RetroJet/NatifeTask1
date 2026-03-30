//
//  PlaceListAssembly.swift
//  NatifeTask1
//
//  Created by Nazar on 29.03.2026.
//

import UIKit

final class PlacesListAssembly {
    static func build(places: [PlaceInfo]) -> UIViewController {
        let placePhotoService = PlacePhotoService()
        let viewController = PlacesListViewController(
            placePhotoService: placePhotoService
        )

        let presenter = PlacesListPresenter(places: places)

        viewController.presenter = presenter

        return viewController
    }
}
