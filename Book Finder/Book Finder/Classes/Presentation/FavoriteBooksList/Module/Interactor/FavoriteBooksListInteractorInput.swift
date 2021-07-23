//
//  FavoriteBooksListInteractorInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Result

protocol FavoriteBooksListInteractorInput: class {

    func getFavoriteBooks(completion: @escaping (Result<[Volume], FavoriteBooksBusinessError>) -> Void)
    func removeFavoriteBook(withId id: String, completion: @escaping (Result<Void, FavoriteBooksBusinessError>) -> Void)
}
