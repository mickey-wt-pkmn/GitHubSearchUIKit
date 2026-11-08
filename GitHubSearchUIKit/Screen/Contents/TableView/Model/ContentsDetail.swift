//
//  ContentsInfo.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

import Foundation

struct ContentsDetail: Hashable {
    let iconImageUrl: URL
    let title: String
    let language: String?
    let star: Int
    let description: String?
    let url: String
}
