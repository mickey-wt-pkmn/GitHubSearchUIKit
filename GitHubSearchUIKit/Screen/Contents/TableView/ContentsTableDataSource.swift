//
//  ContentsTableDataSource.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

import UIKit

final class ContentsTableDataSource: BaseTableViewDataSource<ContentsTableSectionModel> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ContentsTableViewCell.self)
            cell.update(itemIdentifier)
            return cell
        }
    }
    
}
