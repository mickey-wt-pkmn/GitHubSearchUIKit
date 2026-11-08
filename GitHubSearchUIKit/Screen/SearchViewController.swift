//
//  ViewController.swift
//  GitHubSearchUIKit
//
//  Created by mickey-wp on 2026/11/07.
//

import UIKit
import Combine

class SearchViewController: BaseViewController<SearchViewModel> {

    /// 検索テキスト 入力
    @IBOutlet private weak var searchTextField: UITextField!
    /// コンテンツテーブルビュー
    @IBOutlet private weak var contentsTableView: UITableView!
    /// ローディング
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    /// エラーメッセージ
    @IBOutlet private weak var errorLabel: UILabel!
    
    private lazy var dataSource: ContentsTableDataSource = {
        ContentsTableDataSource(tableView: contentsTableView)
    }()
    private let searchQuerySubject = PassthroughSubject<String, Never>()
    
    override func viewDidLoad() {
        viewModel = SearchViewModel()
        setupSearchTextField()
        setupTableView()
        super.viewDidLoad()
    }
    
    private func setupSearchTextField() {
        searchTextField.borderStyle = .roundedRect
        searchTextField.returnKeyType = .search
        searchTextField.placeholder = "検索キーワードを入力"
        searchTextField.delegate = self
    }
    
    private func setupTableView() {
        contentsTableView.register(ContentsTableViewCell.self)
        contentsTableView.separatorStyle = .none
    }
    
    override func bindViewModel() {
        let input = SearchViewModel.Input(
            searchQuery: searchQuerySubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)
        
        output.sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.dataSource.applySections(sections, animatingDifferences: false)
            }
            .store(in: &cancellables)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading
                ? self?.indicator.startAnimating()
                : self?.indicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        output.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.errorLabel.text = message
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchQuerySubject.send(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}

