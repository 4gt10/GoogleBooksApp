//
//  BooksListInteractorInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Foundation
import Result

protocol BooksListInteractorInput: class {

    func searchBooks(query: String, completion: @escaping (Result<[Volume], BooksListBusinessError>) -> Void)
    func manageFavoriteBook(withId id: String, completion: @escaping (Result<Void, BooksListBusinessError>) -> Void)
    func isBookFavorite(bookId: String) -> Bool
}
