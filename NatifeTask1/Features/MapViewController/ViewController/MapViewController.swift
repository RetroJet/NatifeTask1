//
//  MapViewController.swift
//  NatifeTask1
//
//  Created by Nazar on 16.03.2026.
//

import UIKit
import GoogleMaps
import GooglePlacesSwift

final class MapViewController: UIViewController {
    private var placeResults: [PlaceInfo] = []
    private let contentView = MapView()
    private let placesService: IPlacesService
    private let locationManager = CLLocationManager()
    
    
    init(placesService: IPlacesService) {
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

private extension MapViewController {
    func setupView() {
        view.addSubviews(
            contentView
        )
        
        locationManager.delegate = self
    }
}

//MARK: -> Layout Setup
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


//MARK: -> Bindings Setup
extension MapViewController {
    func setupBindings() {
        contentView.onGeoButtonTapped = { [weak self] in
            self?.contentView.centerOnUserLocation()
        }
    }
}

//MARK: -> Places
extension MapViewController {
    func loadPlaces(coordinate: CLLocationCoordinate2D) async {
        do {
            let places = try await placesService.fetchNearbyPlaces(to: coordinate)
            placeResults = places
            contentView.render(places: places)
        } catch {
            if case PlacesServiceError.empty = error {
                showError(error)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
}
// MARK: - Alert
extension MapViewController {
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: nil,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: -> CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        Task {
            await loadPlaces(coordinate: coordinate)
        }
    }
}
