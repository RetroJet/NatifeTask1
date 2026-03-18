//
//  UIView + DisableAutoresizing.swift
//  NatifeTask1
//
//  Created by Nazar on 17.03.2026.
//

import UIKit

extension UIView {
    func disableAutoresizing(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
