//
//  MapViewController.swift
//  NatifeTask1
//
//  Created by Nazar on 16.03.2026.
//

import UIKit
import CoreLocation

protocol MapViewControllerProtocol: AnyObject {
    func render(places: [PlaceInfo])
    func setListButtonEnabled(_ isEnabled: Bool)
    func showPlacesLoadErrorAlert(_ error: Error)
    func showPlacesList(with places: [PlaceInfo])
}

final class MapViewController: UIViewController {

    // MARK: - UI Elements

    private let contentView = MapView()

    // MARK: - Properties

    var presenter: MapPresenterProtocol!
    private let locationManager = CLLocationManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
        setupLayout()
        setupLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Private Methods

private extension MapViewController {
    func setupBindings() {
        contentView.onGeoButtonTapped = { [weak self] in
            self?.setupGeoButtonTap()
        }

        contentView.onListButtonTapped = { [weak self] in
            self?.presenter.showPlacesList()
        }
    }
}

private extension MapViewController {
    func showLocationDeniedAlert() {
        let alert = UIAlertController(
            title: LocationAlertText.locationDeniedTitle,
            message: LocationAlertText.locationDeniedMessage,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: CommonText.okButtonTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: CommonText.settingsButtonTitle, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })

        present(alert, animated: true)
    }

    func showLocationErrorAlert() {
        let alert = UIAlertController(
            title: LocationAlertText.locationErrorTitle,
            message: LocationAlertText.locationErrorMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: CommonText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }
}

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

private extension MapViewController {
    func setupView() {
        view.addSubviews(
            contentView
        )

        locationManager.delegate = self
    }
}

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

// MARK: - MapViewControllerProtocol

extension MapViewController: MapViewControllerProtocol {
    func render(places: [PlaceInfo]) {
        contentView.render(places: places)
    }

    func setListButtonEnabled(_ isEnabled: Bool) {
        contentView.setListButtonEnabled(isEnabled)
    }

    func showPlacesLoadErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: nil,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: CommonText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }

    func showPlacesList(with places: [PlaceInfo]) {
        let viewController = PlacesListAssembly.build(places: places)

        navigationController?.pushViewController(viewController, animated: true)
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
            await presenter.loadPlaces(coordinate: coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showLocationErrorAlert()
    }
}
