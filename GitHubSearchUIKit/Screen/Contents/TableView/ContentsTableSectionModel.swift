//
//  ContentsTableSectionModel.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

import Foundation

struct ContentsTableSectionModel: SectionModelType, Equatable {
    enum SectionID: Hashable {
        case main
    }
    
    typealias Item = ContentsCellViewModel
    
    let id: SectionID
    let items: [Item]
}

extension ContentsTableSectionModel {
    
    struct TableModel {
        let items: [ContentsCellViewModel]
    }
    
    static func makeSectionModels(_ model: TableModel) -> [ContentsTableSectionModel] {
        [ContentsTableSectionModel(id: .main, items: model.items)]
    }
}
