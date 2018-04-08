//
//  BookDetailsInteractor.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Result

enum BookDetailsBusinessError {
    
    case unhandled(error: Error)
}

extension BookDetailsBusinessError: Error {
    
    var localizedDescription: String {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class BookDetailsInteractor {

    private let favoriteBooksService: FavoriteBooksServiceType?
    private let favoriteBooksStorage: FavoriteBooksStorageType?
    
    init(
        favoriteBooksService: FavoriteBooksServiceType?,
        favoriteBooksStorage: FavoriteBooksStorageType?) {
        self.favoriteBooksService = favoriteBooksService
        self.favoriteBooksStorage = favoriteBooksStorage
    }
}

// MARK: - BookDetailsInteractorInput

extension BookDetailsInteractor: BookDetailsInteractorInput {

    func manageFavoriteBook(withId id: String, isFavorite: Bool, completion: @escaping (Result<Void, BookDetailsBusinessError>) -> Void) {
        if isFavorite {
            favoriteBooksService?.removeFavoriteBook(withId: id) { [weak self] result in
                switch result {
                case .success:
                    self?.favoriteBooksStorage?.removeFavoriteBook(withId: id)
                    completion(Result.success(()))
                case .failure(let error):
                    completion(Result.failure(BookDetailsBusinessError.unhandled(error: error)))
                }
            }
        } else {
            favoriteBooksService?.addFavoriteBook(withId: id) { [weak self] result in
                switch result {
                case .success:
                    self?.favoriteBooksStorage?.addFavoriteBook(withId: id)
                    completion(Result.success(()))
                case .failure(let error):
                    completion(Result.failure(BookDetailsBusinessError.unhandled(error: error)))
                }
            }
        }
    }
    
    func isBookFavorite(bookId: String) -> Bool {
        return favoriteBooksStorage?.isBookFavorite(bookId: bookId) ?? false
    }
}
