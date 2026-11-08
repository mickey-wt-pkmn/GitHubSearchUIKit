//
//  SectionModel.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

protocol SectionModelType {
    associatedtype TableModel
    associatedtype Item: Hashable
    associatedtype SectionID: Hashable
    
    var id: SectionID { get }
    var items: [Item] { get }
    
    static func makeSectionModels(_ model: TableModel) -> [Self]
}
