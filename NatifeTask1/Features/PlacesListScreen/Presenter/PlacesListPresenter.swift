//
//  PlacesListPresenter.swift
//  NatifeTask1
//
//  Created by Nazar on 29.03.2026.
//

protocol PlacesListPresenterProtocol {
    func startInitialLoading()
    func getPlacesCount() -> Int
    func getPlaceViewModel(at index: Int) -> PlaceCellViewModel
}

final class PlacesListPresenter {

    // MARK: - Properties
    
    private weak var viewController: PlacesListViewControllerProtocol?
    private let viewModels: [PlaceCellViewModel]
    
    // MARK: - Initializers

    init(viewController: PlacesListViewControllerProtocol, places: [PlaceInfo]) {
        self.viewController = viewController
        self.viewModels = places.map {
            PlaceCellViewModel(
                name: $0.name,
                address: $0.address,
                ratingText: $0.ratingText,
                photo: $0.photo
            )
        }
    }
}

// MARK: - PlacesListPresenterProtocol

extension PlacesListPresenter: PlacesListPresenterProtocol {
    func startInitialLoading() {
        viewController?.reloadData()
    }

    func getPlacesCount() -> Int {
        viewModels.count
    }

    func getPlaceViewModel(at index: Int) -> PlaceCellViewModel {
        viewModels[index]
    }
}
