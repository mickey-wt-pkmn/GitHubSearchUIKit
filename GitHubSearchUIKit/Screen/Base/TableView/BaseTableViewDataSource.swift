//
//  BaseTableViewDataSource.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

import UIKit

class BaseTableViewDataSource<Section: SectionModelType>: UITableViewDiffableDataSource<Section.SectionID, Section.Item> {
    
    func applySections(_ sections: [Section], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section.SectionID, Section.Item>()
        
        for section in sections {
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.items, toSection: section.id)
        }
        
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func model(at indexPath: IndexPath) -> Section.Item? {
        itemIdentifier(for: indexPath)
    }
}
