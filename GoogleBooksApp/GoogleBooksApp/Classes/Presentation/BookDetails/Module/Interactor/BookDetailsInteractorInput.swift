//
//  BookDetailsInteractorInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Result

protocol BookDetailsInteractorInput: class {

    func manageFavoriteBook(withId: String, isFavorite: Bool, completion: @escaping (Result<Void, BookDetailsBusinessError>) -> Void)
    func isBookFavorite(bookId: String) -> Bool
}
