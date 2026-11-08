//
//  UITableView+Reusable.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

import UIKit

extension UITableView {
    
    func register<Cell: BaseTableViewCell>(_ cellType: Cell.Type) {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: BaseTableViewCell>(
        for indexPath: IndexPath,
        cellType: Cell.Type = Cell.self
    ) -> Cell {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellType.reuseIdentifier, for: indexPath
        ) as? Cell else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }
        return cell
    }
}
