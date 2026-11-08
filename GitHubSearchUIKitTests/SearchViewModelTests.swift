//
//  SearchViewModelTests.swift
//  GitHubSearchUIKit
//
//  Created by mickey-wp on 2026/11/08
//
//

import XCTest
import Combine
@testable import GitHubSearchUIKit

@MainActor
final class SearchViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        cancellables.removeAll()
    }
    
    /// 空文字テスト
    func testBlankQueryDoesNotSearch() {
        let service = StubSearchRepositoryService()
        let output = SearchViewModel(searchRepositoryService: service)
            .transform(input: .init(searchQuery: Just("   ").eraseToAnyPublisher()))
        
        let emitted = expectation(description: "sections")
        emitted.isInverted = true
        output.sections.sink { _ in emitted.fulfill() }.store(in: &cancellables)
        wait(for: [emitted], timeout: 0.3)
        
        XCTAssertEqual(service.callCount, 0)
    }
    
    /// 成功テスト
    func testSuccessUpdatesSections() {
        let service = StubSearchRepositoryService()
        service.result = .success(SearchRepositoryResponse(items: [sampleRepository]))
        let output = SearchViewModel(searchRepositoryService: service)
            .transform(input: .init(searchQuery: Just("swift").eraseToAnyPublisher()))
        
        let finished = expectation(description: "sections")
        var titles: [String] = []
        output.sections.sink { sections in
            let received = sections.flatMap(\.items).map(\.detail.title)
            guard !received.isEmpty else { return }
            titles = received
            finished.fulfill()
        }.store(in: &cancellables)
        wait(for: [finished], timeout: 1)
        
        XCTAssertEqual(service.callCount, 1)
        XCTAssertEqual(titles, ["swift"])
    }
    
    /// 失敗テスト
    func testFailureUpdatesErrorMessage() {
        let service = StubSearchRepositoryService()
        service.result = .failure(.responseError)
        let output = SearchViewModel(searchRepositoryService: service)
            .transform(input: .init(searchQuery: Just("swift").eraseToAnyPublisher()))
        
        let finished = expectation(description: "error")
        var message: String?
        output.errorMessage.sink { received in
            guard let received else { return }
            message = received
            finished.fulfill()
        }.store(in: &cancellables)
        wait(for: [finished], timeout: 1)
        
        XCTAssertEqual(service.callCount, 1)
        XCTAssertEqual(message, "レスポンスエラー")
    }
}

// MARK: SampleRepository & StubService

private let sampleRepository = Repository(
    id: 1,
    name: "swift",
    description: "desc",
    stargazersCount: 10,
    language: "Swift",
    htmlUrl: "https://github.com/apple/swift",
    owner: Owner(id: 11, avatarUrl: "https://avatars.githubusercontent.com/u/9919?v=4")
)

private final class StubSearchRepositoryService: SearchRepositoryServiceContract {
    var result: Result<SearchRepositoryResponse, APIServiceError> = .failure(.responseError)
    private(set) var callCount = 0
    func searchRepository(query: String) async -> Result<SearchRepositoryResponse, APIServiceError> {
        callCount += 1
        return result
    }
}
