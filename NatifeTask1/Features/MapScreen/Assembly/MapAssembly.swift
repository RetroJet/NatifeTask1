//
//  MapAssembly.swift
//  NatifeTask1
//
//  Created by Nazar on 29.03.2026.
//

import UIKit
import GooglePlacesSwift

final class MapAssembly {
    static func build() -> UIViewController {
        let placesService = PlacesService(placesClient: .shared)
        let viewController = MapViewController()
        let presenter = MapPresenter(
            viewController: viewController,
            placeService: placesService
        )

        viewController.presenter = presenter

        return viewController
    }
}
