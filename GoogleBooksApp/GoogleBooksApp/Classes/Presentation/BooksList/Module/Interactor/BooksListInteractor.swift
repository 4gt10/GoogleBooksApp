//
//  BooksListInteractor.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Foundation
import Result

final class BooksListInteractor {

    weak var output: BooksListInteractorOutput!
    
    private let service: BooksListServiceType?
    
    init(service: BooksListServiceType?) {
        self.service = service
    }
}

// MARK: - BooksListInteractorInput

extension BooksListInteractor: BooksListInteractorInput {

    func searchBooks(query: String, completion: @escaping (Result<[Volume], BooksListServiceError>) -> Void) {
        service?.searchBooks(query: query, completion: completion)
    }
}
