//
//  MapView.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//

import GoogleMaps
import UIKit

final class MapView: UIView {
    
    // MARK: - Properties
    
    var onGeoButtonTapped: (() -> Void)?
    var onListButtonTapped: (() -> Void)?
    
    // MARK: - UI Elements
    
    private let geoButton = UIButton(configuration: .glass())
    private let listButton = UIButton(configuration: .glass())
    private var mapView: GMSMapView!
    
    // MARK: - Initialization
    
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

// MARK: - Internal Methods

extension MapView {
    func setListButtonEnabled(_ isEnabled: Bool) {
        listButton.isEnabled = isEnabled
        listButton.alpha = isEnabled ? 1.0 : 0.5
    }
}

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

// MARK: - Private Methods

private extension MapView {
    func setupView() {
        addSubviews(
            mapView,
            geoButton,
            listButton
        )
    }
    
    func setupButton() {
        geoButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        geoButton.backgroundColor = .blue
        geoButton.layer.cornerRadius = 25
        geoButton.clipsToBounds = true
        geoButton.addTarget(self, action: #selector(setupGeoButton), for: .touchUpInside)
        
        listButton.setImage(.init(systemName: "list.bullet.rectangle.portrait.fill"), for: .normal)
        listButton.backgroundColor = .white
        listButton.layer.cornerRadius = 25
        listButton.clipsToBounds = true
        listButton.addTarget(self, action: #selector(setupListButton), for: .touchUpInside)
        
        setListButtonEnabled(false)
    }
    
    @objc
    func setupGeoButton() {
        onGeoButtonTapped?()
    }
    
    @objc
    func setupListButton() {
        onListButtonTapped?()
    }
}

private extension MapView {
    func setupLayout() {
        disableAutoresizing(
            mapView,
            geoButton,
            listButton
        )
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            geoButton.widthAnchor.constraint(equalToConstant: 60),
            geoButton.heightAnchor.constraint(equalToConstant: 60),
            geoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            geoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            listButton.widthAnchor.constraint(equalToConstant: 60),
            listButton.heightAnchor.constraint(equalToConstant: 60),
            listButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            listButton.bottomAnchor.constraint(equalTo: geoButton.topAnchor, constant: -20),
        ])
    }
}
