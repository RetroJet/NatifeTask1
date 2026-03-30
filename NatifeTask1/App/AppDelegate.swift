//
//  AppDelegate.swift
//  NatifeTask1
//
//  Created by Nazar on 16.03.2026.
//

import UIKit
import GoogleMaps
import GooglePlaces
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let path = Bundle.main.path(forResource: "Environment", ofType: "plist"),
              let config = try? NSDictionary(contentsOf: URL(fileURLWithPath: path), error: ()),
              let apiKey = config["GOOGLE_API_KEY"] as? String else {
            fatalError("Wrong GOOGLE_API_KEY")
        }
        
        GMSPlacesClient.provideAPIKey(apiKey)
        GMSServices.provideAPIKey(apiKey)
        
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
        
        return true
    }
}

