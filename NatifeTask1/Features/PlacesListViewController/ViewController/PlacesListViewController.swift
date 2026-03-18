//
//  PlacesListViewController.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit

class PlacesListViewController: UIViewController {
    private let contentView = PlacesListView()
    private let reuseIdentifier = "reuseIdentifier"
    private var places: [PlaceInfo] = []
    
    init(places: [PlaceInfo]) {
        self.places = places
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Views
private extension PlacesListViewController {
    func setupView() {
        view.addSubview(contentView)
        
        contentView.configureTableView(dataSource: self)
        contentView.register(PlaceCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func setupNavigationBar() {
        title = "List"
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .separator
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
}

// MARK: - Layout
private extension PlacesListViewController {
    func setupLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension PlacesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PlaceCell
        let place = places[indexPath.row]
        cell.configure(with: place)
        return cell
    }
}
