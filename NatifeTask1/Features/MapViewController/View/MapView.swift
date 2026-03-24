//
//  MapView.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//

import UIKit
import GoogleMaps

final class MapView: UIView {
    private let geoButton = UIButton(configuration: .glass())
    private var mapView: GMSMapView!
    
    var onGeoButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupMap()
        setupButton()
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Views
private extension MapView {
    func setupView() {
        addSubviews(
            mapView,
            geoButton
        )
    }
    
    func setupButton() {
        geoButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        geoButton.backgroundColor = .blue
        geoButton.layer.cornerRadius = 25
        geoButton.clipsToBounds = true
        geoButton.addTarget(self, action: #selector(pressedGeoButton), for: .touchUpInside)
    }
    
    @objc
    func pressedGeoButton() {
        onGeoButtonTapped?()
    }
}

// MARK: - Layout
private extension MapView {
    func setupLayout() {
        disableAutoresizing(
            mapView,
            geoButton
        )
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            geoButton.widthAnchor.constraint(equalToConstant: 50),
            geoButton.heightAnchor.constraint(equalToConstant: 50),
            geoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            geoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
}


// MARK: - Map
extension MapView {
    func setupMap() {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 6.0)
        mapView = GMSMapView(options: options)
        mapView.isMyLocationEnabled = true
    }
    
    func center(on coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(target: coordinate, zoom: 15)
        mapView.animate(to: camera)
    }
    
    func centerOnUserLocation() {
        guard let coordinate = mapView.myLocation?.coordinate else { return }
        center(on: coordinate)
    }

    
    func render(places: [PlaceInfo]) {
        mapView.clear()
        
        for place in places {
            let marker = GMSMarker()
            marker.snippet = [place.detailsText, place.address]
                .compactMap { $0 }
                .joined(separator: "\n")
            marker.position = place.coordinate
            marker.title = place.name
            marker.map = mapView
        }
    }
}
