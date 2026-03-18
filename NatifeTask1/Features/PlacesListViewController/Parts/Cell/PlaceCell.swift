//
//  PlaceCell.swift
//  NatifeTask1
//
//  Created by Nazar on 18.03.2026.
//

import UIKit

class PlaceCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let rating = UILabel()
    private let addressLabel = UILabel()
    private let placeImage = UIImageView()
    private var photoTask: Task<Void, Never>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImage()
        setupLabel()
        setupView()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoTask?.cancel()
        photoTask = nil
        titleLabel.text = nil
        rating.text = nil
        addressLabel.text = nil
        placeImage.image = .noImagePlaceholder
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Views
private extension PlaceCell {
    func setupView() {
        contentView.addSubviews(
            titleLabel,
            addressLabel,
            rating,
            placeImage
        )
        
        selectionStyle = .none
    }
    
    func setupLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        addressLabel.font = UIFont.systemFont(ofSize: 18)
        addressLabel.numberOfLines = 0
        
        rating.font = UIFont.systemFont(ofSize: 16)
        rating.numberOfLines = 1
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
            titleLabel,
            addressLabel,
            rating,
            placeImage
        )
        
        NSLayoutConstraint.activate([
            placeImage.widthAnchor.constraint(equalToConstant: 70),
            placeImage.heightAnchor.constraint(equalToConstant: 70),
            placeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            placeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: placeImage.leadingAnchor, constant: -16),
            
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            rating.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            rating.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            rating.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            rating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - Formatting
private extension PlaceCell {
    func makeRatingText(from value: Float) -> String {
        let starsCount = Int(round(value))
        let stars = String(repeating: "⭐", count: starsCount)
        return "\(String(format: "%.1f", value)) \(stars)"
    }
}


// MARK: - Configuration
extension PlaceCell {
    func configure(with place: PlaceInfo) {
        titleLabel.text = place.name
        addressLabel.text = place.address
        
        if let ratingValue = place.rating {
            rating.text = makeRatingText(from: ratingValue)
        } else {
            rating.text = nil
        }
        
        if let photo = place.photo {
            photoTask = placeImage.loadPhoto(photo)
        }
    }
}
