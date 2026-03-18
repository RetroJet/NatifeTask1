//
//  SceneDelegate.swift
//  NatifeTask1
//
//  Created by Nazar on 16.03.2026.
//

import UIKit
import GooglePlacesSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let placeClient = PlacesClient.shared
        let placesService = PlacesService(placesClient: placeClient)
        let mapViewController = MapViewController(placesService: placesService)
        let navigationController = UINavigationController(rootViewController: mapViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
