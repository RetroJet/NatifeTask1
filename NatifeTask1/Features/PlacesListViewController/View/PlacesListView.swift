//
//  PlacesListView.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit

class PlacesListView: UIView {
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupTableView()
        setupView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Views
private extension PlacesListView {
    func setupView() {
        addSubview(tableView)
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
        tableView.separatorInset = .zero
    }
}

// MARK: - Layout
private extension PlacesListView {
    func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Table View
extension PlacesListView {
    func configureTableView(dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
}
