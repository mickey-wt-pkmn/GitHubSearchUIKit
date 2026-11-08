//
//  AnyPublisher+DeferredTask.swift.swift
//  GitHubSearchUIKit
//  
//  Created by mickey-wp on 2026/11/07
//  
//

import Combine

func deferredTask<Output: Sendable>(
    _ operation: @escaping @Sendable () async throws -> Output
) -> AnyPublisher<Output, Error> {
    
    Deferred {
        let subject = PassthroughSubject<Output, Error>()
        let task = Task {
            do {
                subject.send(try await operation())
                subject.send(completion: .finished)
            } catch is CancellationError {
                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        return subject
            .handleEvents(receiveCancel: { task.cancel() })
            .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
}
