//
//  ContentsCellViewModel.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

struct ContentsCellViewModel: Hashable {
    let detail: ContentsDetail
    
    init(detail: ContentsDetail) {
        self.detail = detail
    }
}
