//
//  UIView + AddSubviews.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
