//
//  BaseViewController.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

import UIKit
import Combine

class BaseViewController<ViewModel: ViewModelType>: UIViewController {
    
    final var viewModel: ViewModel!
    final var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    /// VM とのバインド(継承先で実装)
    func bindViewModel() {}
}
