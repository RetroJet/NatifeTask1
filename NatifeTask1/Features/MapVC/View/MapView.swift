//
//  MapView.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//

import SwiftUI
import UIKit
import GoogleMaps
import GooglePlacesSwift

struct MapViewPreview: UIViewRepresentable {}

final class MapView: UIView {
    private let geoButton = UIButton(configuration: .glass())
    
    private var mapView: GMSMapView!
    
    var onGeoButtonTapped: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -> Setup View
private extension MapView {
    func setup() {
        setupMap()
        setupButton()
        setupView()
        setupLayout()
    }
    
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

//MARK: -> Setup Map
extension MapView {
    var userLocation: CLLocationCoordinate2D? {
        mapView.myLocation?.coordinate
    }
    
    func setupMap() {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView(options: options)
        mapView.isMyLocationEnabled = true
    }
    
    func animateCamera(to coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(target: coordinate, zoom: 15)
        mapView.animate(to: camera)
    }
    
    func addMarkers(_ places: [PlaceInfo]) {
        for place in places {
            let marker = GMSMarker()
            marker.snippet = [place.country, place.city, place.address]
                .compactMap { $0 }
                .joined(separator: "\n")
            marker.position = place.coordinate
            marker.title = place.displayName
            marker.map = mapView
        }
    }
}

//MARK: -> Setup Layout
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
            geoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }
}

//MARK: -> Preview
extension MapViewPreview {
    func makeUIView(context: Context) -> UIView {
        MapView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


#Preview {
    MapViewPreview().ignoresSafeArea()
}
