//
//  BooksListService.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Result

enum BooksListServiceError {
    
    case unhandled(error: Error)
}

extension BooksListServiceError: Error {
    
    var localizedDescription: String {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol BooksListServiceType {
    
    func searchBooks(query: String, completion: @escaping (Result<[Volume], BooksListServiceError>) -> Void)
}

final class BooksListService {
    
    private let requestSender: RequestSender
    private let authorizationService: AuthorizationServiceType?
    
    // MARK: - Init
    
    init(requestSender: RequestSender, authorizationService: AuthorizationServiceType?) {
        self.requestSender = requestSender
        self.authorizationService = authorizationService
    }
}

extension BooksListService: BooksListServiceType {
    
    func searchBooks(query: String, completion: @escaping (Result<[Volume], BooksListServiceError>) -> Void) {
        authorizationService?.authorize { [weak self] result in
            switch result {
            case .success:
                self?.requestSender.sendRequest(requestSpecification: BooksListAPIRequestSpecification.searchBooks(query: query)) { (result: Result<VolumesList, APIError>) in
                    switch result {
                    case .success(let volumesList): completion(Result.success(volumesList.items))
                    case .failure(let error): completion(Result.failure(BooksListServiceError.unhandled(error: error)))
                    }
                }
            case .failure(let error):
                completion(Result.failure(BooksListServiceError.unhandled(error: error)))
            }
        }
    }
}
