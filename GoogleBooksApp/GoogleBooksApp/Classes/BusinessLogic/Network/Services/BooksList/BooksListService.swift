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
    
    private let apiProvider: OAuthAPIProvider?
    
    // MARK: - Init
    
    init(apiProvider: OAuthAPIProvider?) {
        self.apiProvider = apiProvider
    }
}

extension BooksListService: BooksListServiceType {
    
    func searchBooks(query: String, completion: @escaping (Result<[Volume], BooksListServiceError>) -> Void) {
        apiProvider?.sendRequest(
            requestSpecification: BooksListAPIRequestSpecification.searchBooks(query: query)) { (result: Result<VolumesList, APIError>) in
            switch result {
            case .success(let volumesList): completion(Result.success(volumesList.items ?? []))
            case .failure(let error): completion(Result.failure(BooksListServiceError.unhandled(error: error)))
            }
        }
    }
}
