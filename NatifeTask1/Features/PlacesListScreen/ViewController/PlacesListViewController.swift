//
//  PlacesListViewController.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit

protocol PlacesListViewControllerProtocol: AnyObject {
    func reloadData()
}

final class PlacesListViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.register(cell: PlaceCell.self)
        return tableView
    }()

    // MARK: - Properties

    var presenter: PlacesListPresenterProtocol!
    private let placePhotoService: PlacePhotoServiceProtocol

    // MARK: - Initializers

    init(placePhotoService: PlacePhotoServiceProtocol) {
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
        setupNavigationBar()
        setupView()
        setupLayout()
        presenter.startInitialLoading()
    }
}

// MARK: - Private Methods

private extension PlacesListViewController {
    func setupView() {
        view.addSubview(tableView)
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

// MARK: - PlacesListViewControllerProtocol

extension PlacesListViewController: PlacesListViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PlacesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getPlacesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceCell = tableView.dequeue(for: indexPath)
        let viewModel = presenter.getPlaceViewModel(at: indexPath.row)
        cell.configure(
            with: viewModel,
            placePhotoService: placePhotoService
        )
        return cell
    }
}
