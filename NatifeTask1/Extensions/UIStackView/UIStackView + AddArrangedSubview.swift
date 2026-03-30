//
//  UIStackView + AddArrangedSubview.swift
//  NatifeTask1
//
//  Created by Nazar on 26.03.2026.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
}
