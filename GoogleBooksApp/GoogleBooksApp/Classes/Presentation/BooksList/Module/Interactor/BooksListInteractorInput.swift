//
//  BooksListInteractorInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Foundation
import Result

protocol BooksListInteractorInput: class {

    func searchBooks(query: String, completion: @escaping (Result<[Volume], BooksListServiceError>) -> Void)
}
