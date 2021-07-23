//
//  BooksListInteractor.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Foundation
import Result

enum BooksListBusinessError {
    
    case unhandled(error: Error)
}

extension BooksListBusinessError: Error {
    
    var localizedDescription: String {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class BooksListInteractor {

    private let booksListService: BooksListServiceType?
    private let favoriteBooksService: FavoriteBooksServiceType?
    private let favoriteBooksStorage: FavoriteBooksStorageType?
    
    init(
        booksListService: BooksListServiceType?,
        favoriteBooksService: FavoriteBooksServiceType?,
        favoriteBooksStorage: FavoriteBooksStorageType?) {
        self.booksListService = booksListService
        self.favoriteBooksService = favoriteBooksService
        self.favoriteBooksStorage = favoriteBooksStorage
    }
}

// MARK: - BooksListInteractorInput

extension BooksListInteractor: BooksListInteractorInput {

    func searchBooks(query: String, completion: @escaping (Result<[Volume], BooksListBusinessError>) -> Void) {
        booksListService?.searchBooks(query: query) { result in
            switch result {
            case .success(let volumes):
                completion(Result.success(volumes))
            case .failure(let error):
                completion(Result.failure(BooksListBusinessError.unhandled(error: error)))
            }
        }
    }
    
    func manageFavoriteBook(withId id: String, completion: @escaping (Result<Void, BooksListBusinessError>) -> Void) {
        favoriteBooksService?.getFavoriteBooks() { [weak self] result in
            switch result {
            case .success(let favoriteVolumes):
                let isFavorite = favoriteVolumes.contains(where: { $0.id == id })
                if isFavorite {
                    self?.favoriteBooksService?.removeFavoriteBook(withId: id) { [weak self] result in
                        switch result {
                        case .success:
                            self?.favoriteBooksStorage?.removeFavoriteBook(withId: id)
                            completion(Result.success(()))
                        case .failure(let error):
                            completion(Result.failure(BooksListBusinessError.unhandled(error: error)))
                        }
                    }
                } else {
                    self?.favoriteBooksService?.addFavoriteBook(withId: id) { [weak self] result in
                        switch result {
                        case .success:
                            self?.favoriteBooksStorage?.addFavoriteBook(withId: id)
                            completion(Result.success(()))
                        case .failure(let error):
                            completion(Result.failure(BooksListBusinessError.unhandled(error: error)))
                        }
                    }
                }
            case .failure(let error):
                completion(Result.failure(BooksListBusinessError.unhandled(error: error)))
            }
        }
    }
    
    func isBookFavorite(bookId: String) -> Bool {
        return favoriteBooksStorage?.isBookFavorite(bookId: bookId) ?? false
    }
}
