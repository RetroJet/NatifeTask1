//
//  PlaceCell.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit

final class PlaceCell: UITableViewCell {
    private enum Constants {
        static let photoMaxSize = CGSize(width: 140, height: 140)
    }
    
    // MARK: - Private Properties
    private let textStackView = UIStackView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let addressLabel = UILabel()
    private let placeImage = UIImageView()
    private var photoTask: Task<Void, Never>?
    
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImage()
        setupLabel()
        setupStackView()
        setupView()
        setupLayout()
    }
    
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

// MARK: - Configuration
extension PlaceCell {
    func configure(with place: PlaceInfo, placePhotoService: PlacePhotoServiceProtocol) {
        photoTask?.cancel()
        photoTask = nil
        
        titleLabel.text = place.name
        addressLabel.text = place.address
        placeImage.image = .noImagePlaceholder
        ratingLabel.text = place.ratingText
        ratingLabel.isHidden = place.ratingText == nil
        
        guard let photo = place.photo else { return }
        
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

// MARK: - Views
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
        
        textStackView.axis = .vertical
        textStackView.spacing = 5
        textStackView.alignment = .fill
        textStackView.distribution = .fill
    }
    
    func setupLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        addressLabel.font = UIFont.systemFont(ofSize: 18)
        addressLabel.numberOfLines = 0
        
        ratingLabel.font = UIFont.systemFont(ofSize: 16)
        ratingLabel.numberOfLines = 1
    }
    
    func setupImage() {
        placeImage.layer.cornerRadius = 20
        placeImage.clipsToBounds = true
        placeImage.contentMode = .scaleAspectFill
        placeImage.image = .noImagePlaceholder
    }
}

// MARK: - Layout
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
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
}
