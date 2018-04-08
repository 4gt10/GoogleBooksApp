//
//  FavoriteBooksService.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Result

enum FavoriteBooksServiceError {
    
    case unhandled(error: Error)
}

extension FavoriteBooksServiceError: Error {
    
    var localizedDescription: String {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol FavoriteBooksServiceType {
    
    func getFavoriteBooks(completion: @escaping (Result<[Volume], FavoriteBooksServiceError>) -> Void)
    func addFavoriteBook(withId: String, completion: @escaping (Result<Bool, FavoriteBooksServiceError>) -> Void)
    func removeFavoriteBook(withId: String, completion: @escaping (Result<Bool, FavoriteBooksServiceError>) -> Void)
}

final class FavoriteBooksService {
    
    private let requestSender: RequestSender
    private let authorizationService: AuthorizationServiceType?
    
    // MARK: - Init
    
    init(requestSender: RequestSender, authorizationService: AuthorizationServiceType?) {
        self.requestSender = requestSender
        self.authorizationService = authorizationService
    }
}

extension FavoriteBooksService: FavoriteBooksServiceType {

    func getFavoriteBooks(completion: @escaping (Result<[Volume], FavoriteBooksServiceError>) -> Void) {
        authorizationService?.authorize { [weak self] result in
            switch result {
            case .success:
                self?.requestSender.sendRequest(requestSpecification: FavoriteBooksAPIRequestSpecification.favoriteBooksList) { (result: Result<VolumesList, APIError>) in
                    switch result {
                    case .success(let volumesList): completion(Result.success(volumesList.items))
                    case .failure(let error): completion(Result.failure(FavoriteBooksServiceError.unhandled(error: error)))
                    }
                }
            case .failure(let error):
                completion(Result.failure(FavoriteBooksServiceError.unhandled(error: error)))
            }
        }
        
    }
    
    func addFavoriteBook(withId id: String, completion: @escaping (Result<Bool, FavoriteBooksServiceError>) -> Void) {
        authorizationService?.authorize { [weak self] result in
            switch result {
            case .success:
                self?.requestSender.sendRequest(requestSpecification: FavoriteBooksAPIRequestSpecification.addFavoriteBook(id: id)) { (result: Result<Bool, APIError>) in
                    switch result {
                    case .success(_): completion(Result.success(true))
                    case .failure(let error): completion(Result.failure(FavoriteBooksServiceError.unhandled(error: error)))
                    }
                }
            case .failure(let error):
                completion(Result.failure(FavoriteBooksServiceError.unhandled(error: error)))
            }
        }
    }
    
    func removeFavoriteBook(withId id: String, completion: @escaping (Result<Bool, FavoriteBooksServiceError>) -> Void) {
        authorizationService?.authorize { [weak self] result in
            switch result {
            case .success:
                self?.requestSender.sendRequest(requestSpecification: FavoriteBooksAPIRequestSpecification.removeFavoriteBook(id: id)) { (result: Result<Bool, APIError>) in
                    switch result {
                    case .success(_): completion(Result.success(true))
                    case .failure(let error): completion(Result.failure(FavoriteBooksServiceError.unhandled(error: error)))
                    }
                }
            case .failure(let error):
                completion(Result.failure(FavoriteBooksServiceError.unhandled(error: error)))
            }
        }
    }
}
