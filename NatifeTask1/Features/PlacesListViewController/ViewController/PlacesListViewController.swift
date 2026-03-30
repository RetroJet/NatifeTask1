//
//  PlacesListViewController.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit

final class PlacesListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let tableView = UITableView()
    
    // MARK: - Properties
    
    private let placePhotoService: PlacePhotoServiceProtocol
    private var places: [PlaceInfo] = []
    
    // MARK: - Initializers
    
    init(
        places: [PlaceInfo],
        placePhotoService: PlacePhotoServiceProtocol
    ) {
        self.places = places
        self.placePhotoService = placePhotoService
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupView()
        setupLayout()
    }
}

// MARK: - Private Methods

private extension PlacesListViewController {
    func setupView() {
        view.addSubview(tableView)
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.separatorInset = .zero
        
        tableView.dataSource = self
        tableView.register(cell: PlaceCell.self)
    }
    
    func setupNavigationBar() {
        title = PlacesListText.title
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .separator
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
}

private extension PlacesListViewController {
    func setupLayout() {
        view.disableAutoresizing(
            tableView
        )
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

private extension PlacesListViewController {
    enum Constants {
        static let estimatedRowHeight: CGFloat = 110
    }
}

// MARK: - UITableViewDataSource
extension PlacesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceCell = tableView.dequeue(for: indexPath)
        let place = places[indexPath.row]
        cell.configure(
            with: place,
            placePhotoService: placePhotoService
        )
        return cell
    }
}
