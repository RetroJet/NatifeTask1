//
//  MacpVC.swift
//  NatifeTask1
//
//  Created by Nazar on 16.03.2026.
//

import SwiftUI
import UIKit
import GoogleMaps
import GooglePlacesSwift


struct MapVCPreview: UIViewControllerRepresentable {}

final class MapVC: UIViewController {
    private var placeResults: [PlaceInfo] = []
    
    private let contentView = MapView()
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: -> Setup View
private extension MapVC {
    func setup() {
        setupBindigs()
        setupView()
        setupLayout()
        
        Task {
            await loadPlaces()
        }
    }
    
    func setupView() {
        view.addSubviews(
            contentView
        )
    }
}

//MARK: -> Setup Bindigs
extension MapVC {
    func setupBindigs() {
        contentView.onGeoButtonTapped = { [weak self] in
            guard let coordinate = self?.contentView.userLocation else { return }
            self?.contentView.animateCamera(to: coordinate)
        }
    }
}

//MARK: -> Data Source
extension MapVC {
    func loadPlaces() async {
        guard let coordinate = contentView.userLocation else { return }
        placeResults = await networkManager.fetchNearbyPlaces(to: coordinate)
        contentView.addMarkers(placeResults)
    }
}

//MARK: -> SetupLayout
extension MapVC {
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

//MARK: -> Preview
extension MapVCPreview {
    func makeUIViewController(context: Context) -> UIViewController {
        MapVC()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


#Preview {
    MapVCPreview().ignoresSafeArea()
}
