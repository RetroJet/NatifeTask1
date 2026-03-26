//
//  UITableView + Reusable.swift
//  NatifeTask1
//
//  Created by Nazar on 26.03.2026.
//

import UIKit

protocol SelfIdentifiable {}

extension SelfIdentifiable {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: SelfIdentifiable {}

extension UITableView {
    func register<Cell: UITableViewCell>(cell: Cell.Type) {
        self.register(cell.self, forCellReuseIdentifier: cell.identifier)
    }
    
    func dequeue<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            fatalError("Cell \(String(describing: Cell.self)) not registered")
        }
        return cell
    }
}
