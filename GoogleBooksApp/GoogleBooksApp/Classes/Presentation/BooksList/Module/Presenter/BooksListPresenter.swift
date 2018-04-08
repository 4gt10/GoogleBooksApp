//
//  BooksListPresenter.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Foundation

final class BooksListPresenter {

    // MARK: - Properties

    weak var view: BooksListViewInput!
    var interactor: BooksListInteractorInput!
    var router: BooksListRouterInput!
}

// MARK: - BooksListViewOutput

extension BooksListPresenter: BooksListViewOutput {

    func viewIsReady() {
        view.setupInitialState()
    }
    
    // FIXME: Test
    func getTestBooks() {
        interactor.searchBooks(query: "Harry") { result in
            switch result {
            case .success(let books):
                print(books)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - BooksListInteractorOutput

extension BooksListPresenter: BooksListInteractorOutput {

}

// MARK: - BooksListModuleInput

extension BooksListPresenter: BooksListModuleInput {

}
