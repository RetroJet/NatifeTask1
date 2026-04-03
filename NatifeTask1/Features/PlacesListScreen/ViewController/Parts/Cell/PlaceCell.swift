//
//  PlaceCell.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit

final class PlaceCell: UITableViewCell {

    // MARK: - UI Elements

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    private lazy var placeImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = .noImagePlaceholder
        return image
    }()

    // MARK: - Properties

    private var photoTask: Task<Void, Never>?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupView()
        setupLayout()
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        photoTask?.cancel()
        photoTask = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        ratingLabel.isHidden = false
        addressLabel.text = nil
        placeImage.image = .noImagePlaceholder
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension PlaceCell {
    func configure(with viewModel: PlaceCellViewModel, placePhotoService: PlacePhotoServiceProtocol) {
        photoTask?.cancel()
        photoTask = nil

        titleLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        placeImage.image = .noImagePlaceholder
        ratingLabel.text = viewModel.ratingText
        ratingLabel.isHidden = viewModel.ratingText == nil

        guard let photo = viewModel.photo else { return }

        photoTask = Task { [weak self] in
            let image = await placePhotoService.fetchPhoto(
                from: photo,
                maxSize: Constants.photoMaxSize
            )

            guard !Task.isCancelled else { return }

            await MainActor.run {
                self?.placeImage.image = image ?? .noImagePlaceholder
            }
        }
    }
}

// MARK: - Private Methods

private extension PlaceCell {
    func setupView() {
        contentView.addSubviews(
            placeImage,
            textStackView
        )

        selectionStyle = .none
    }

    func setupStackView() {
        textStackView.addArrangedSubviews(
            titleLabel,
            addressLabel,
            ratingLabel
        )
    }
}

private extension PlaceCell {
    func setupLayout() {
        contentView.disableAutoresizing(
            placeImage,
            textStackView
        )

        NSLayoutConstraint.activate([
            placeImage.widthAnchor.constraint(equalToConstant: 70),
            placeImage.heightAnchor.constraint(equalToConstant: 70),
            placeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            placeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            textStackView.trailingAnchor.constraint(equalTo: placeImage.leadingAnchor, constant: -30),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

private extension PlaceCell {
    enum Constants {
        static let photoMaxSize = CGSize(width: 140, height: 140)
    }
}
