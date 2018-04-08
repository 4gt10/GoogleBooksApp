//
//  FavoriteBooksListInteractor.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Result

enum FavoriteBooksBusinessError {
    
    case unhandled(error: Error)
}

extension FavoriteBooksBusinessError: Error {
    
    var localizedDescription: String {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class FavoriteBooksListInteractor {

    private let favoriteBooksService: FavoriteBooksServiceType?
    private let favoriteBooksStorage: FavoriteBooksStorageType?
    
    init(
        favoriteBooksService: FavoriteBooksServiceType?,
        favoriteBooksStorage: FavoriteBooksStorageType?) {
        self.favoriteBooksService = favoriteBooksService
        self.favoriteBooksStorage = favoriteBooksStorage
    }
}

// MARK: - FavoriteBooksListInteractorInput

extension FavoriteBooksListInteractor: FavoriteBooksListInteractorInput {

    func getFavoriteBooks(completion: @escaping (Result<[Volume], FavoriteBooksBusinessError>) -> Void) {
        favoriteBooksService?.getFavoriteBooks() { result in
            switch result {
            case .success(let favoriteVolumes):
                completion(Result.success(favoriteVolumes))
            case .failure(let error):
                completion(Result.failure(FavoriteBooksBusinessError.unhandled(error: error)))
            }
        }
    }
    
    func removeFavoriteBook(withId id: String, completion: @escaping (Result<Void, FavoriteBooksBusinessError>) -> Void) {
        favoriteBooksService?.removeFavoriteBook(withId: id) { [weak self] result in
            switch result {
            case .success:
                self?.favoriteBooksStorage?.removeFavoriteBook(withId: id)
                completion(Result.success(()))
            case .failure(let error):
                completion(Result.failure(FavoriteBooksBusinessError.unhandled(error: error)))
            }
        }
    }
}
