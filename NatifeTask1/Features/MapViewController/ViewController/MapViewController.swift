//
//  MapViewController.swift
//  NatifeTask1
//
//  Created by Nazar on 16.03.2026.
//

import UIKit
import CoreLocation

private enum AlertText {
    static let locationDeniedTitle = "Location Access Needed"
    static let locationDeniedMessage = "Please allow access to your location to show nearby places on the map."
    static let locationErrorTitle = "Location Error"
    static let locationErrorMessage = "Unable to determine your location. Please try again."
    static let okButtonTitle = "OK"
    static let settingsButtonTitle = "Settings"
}

final class MapViewController: UIViewController {
    private let contentView = MapView()
    private let placesService: PlacesServiceProtocol
    private let locationManager = CLLocationManager()
    
    
    init(placesService: PlacesServiceProtocol) {
        self.placesService = placesService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
        setupLayout()
        setupLocation()
    }
}

// MARK: - Views
private extension MapViewController {
    func setupView() {
        view.addSubviews(
            contentView
        )
        
        locationManager.delegate = self
    }
}

// MARK: - Layout
private extension MapViewController {
    func setupLayout() {
        view.disableAutoresizing(
            contentView
        )
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - Bindings
private extension MapViewController {
    func setupBindings() {
        contentView.onGeoButtonTapped = { [weak self] in
            self?.setupGeoButtonTap()
        }
    }
}

// MARK: - Places
private extension MapViewController {
    func loadPlaces(coordinate: CLLocationCoordinate2D) async {
        do {
            let places = try await placesService.fetchNearbyPlaces(to: coordinate)
            contentView.render(places: places)
        } catch {
            if case let PlacesServiceError.loadFailed(error) = error {
                print(error.localizedDescription)
            }
            showPlacesLoadErrorAlert(error)
        }
    }
}

// MARK: - Alerts
private extension MapViewController {
    func showPlacesLoadErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: nil,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AlertText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }
    
    func showLocationDeniedAlert() {
        let alert = UIAlertController(
            title: AlertText.locationDeniedTitle,
            message: AlertText.locationDeniedMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: AlertText.okButtonTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: AlertText.settingsButtonTitle, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
    
    func showLocationErrorAlert() {
        let alert = UIAlertController(
            title: AlertText.locationErrorTitle,
            message: AlertText.locationErrorMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AlertText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Location Flow
private extension MapViewController {
    func handleLocationAuthorization(
        onAuthorized: () -> Void
    ) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            onAuthorized()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showLocationDeniedAlert()
        @unknown default:
            break
        }
    }
    
    func setupLocation() {
        handleLocationAuthorization {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupGeoButtonTap() {
        handleLocationAuthorization {
            contentView.centerOnUserLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationDeniedAlert()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        manager.stopUpdatingLocation()
        
        contentView.center(on: coordinate)
        
        Task {
            await loadPlaces(coordinate: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showLocationErrorAlert()
    }
}
