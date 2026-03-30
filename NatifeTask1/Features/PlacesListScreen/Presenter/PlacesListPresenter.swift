//
//  PlacesListPresenter.swift
//  NatifeTask1
//
//  Created by Nazar on 29.03.2026.
//

protocol PlacesListPresenterProtocol {
    func getPlacesCount() -> Int
    func getPlace(by index: Int) -> PlaceInfo
}

final class PlacesListPresenter {
    
    // MARK: - Properties
    
    private var places: [PlaceInfo] = []
    
    // MARK: - Initializers
    
    init(places: [PlaceInfo]) {
        self.places = places
    }
}

// MARK: - PlacesListPresenterProtocol

extension PlacesListPresenter: PlacesListPresenterProtocol {
    func getPlacesCount() -> Int {
        places.count
    }
    
    func getPlace(by index: Int) -> PlaceInfo {
        places[index]
    }
}
