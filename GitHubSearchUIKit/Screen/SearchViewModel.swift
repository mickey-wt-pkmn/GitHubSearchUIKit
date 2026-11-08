//
//  ViewModel.swift
//  GitHubSearchUIKit
//
//  Created by mickey-wp on 2026/11/07
//
//

import Foundation
import Combine

final class SearchViewModel: ViewModelType {
    
    private enum SearchState: Equatable {
        case loading
        case success([ContentsTableSectionModel])
        case failure(String)
    }
    
    private let searchRepositoryService: SearchRepositoryServiceContract
    
    init(searchRepositoryService: SearchRepositoryServiceContract = SearchRepositoryService()) {
        self.searchRepositoryService = searchRepositoryService
    }
    
    func transform(input: Input) -> Output {
        
        let state = input.searchQuery
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { query in
                self.search(query: query)
            }
            .switchToLatest()
            .eraseToAnyPublisher()

        
        let sections = state
            .map { state -> [ContentsTableSectionModel] in
                if case .success(let sections) = state { return sections }
                return []
            }
            .eraseToAnyPublisher()
        
        let isLoading = state
            .map { $0 == SearchState.loading }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let errorMessage = state
            .map { state -> String? in
                if case .failure(let message) = state { return message }
                return nil
            }
            .eraseToAnyPublisher()
        
        return Output(
            sections: sections,
            isLoading: isLoading,
            errorMessage: errorMessage
        )
    }
    
    private func search(query: String) -> AnyPublisher<SearchState, Never> {
        deferredTask { [searchRepositoryService] in
            let result = await searchRepositoryService.searchRepository(query: query)
            guard !Task.isCancelled else {
                throw CancellationError()
            }
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }
        .map(makeState)
        .catch { Just(SearchState.failure($0.localizedDescription)) }
        .prepend(.loading)
        .eraseToAnyPublisher()
    }
    
    private func makeState(response: SearchRepositoryResponse) -> SearchState {
        let items = response.items.compactMap { repo -> ContentsCellViewModel? in
            guard let url = URL(string: repo.owner.avatarUrl) else {
                return nil
            }
            let detail = ContentsDetail(
                iconImageUrl: url,
                title: repo.name,
                language: repo.language,
                star: repo.stargazersCount,
                description: repo.description,
                url: repo.htmlUrl
            )
            return ContentsCellViewModel(detail: detail)
        }
        let sections = ContentsTableSectionModel.makeSectionModels(.init(items: items))
        return .success(sections)
    }
}

extension SearchViewModel {
    struct Input {
        let searchQuery: AnyPublisher<String, Never>
    }
    
    struct Output {
        let sections: AnyPublisher<[ContentsTableSectionModel], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
    }
}
