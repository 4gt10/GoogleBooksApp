//
//  BooksListPresenter.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Foundation

final class BooksListPresenter {

    // MARK: - Properties

    weak var view: BooksListViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
            view.searchBooks = { [weak self] query in
                self?.interactor.searchBooks(query: query) { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let volumes):
                        self.volumes = volumes
                        self.view.update(withItems: volumes.map { VolumeViewModel(model: $0, isFavorite: self.interactor.isBookFavorite(bookId: $0.id)) })
                    case .failure(let error):
                        self.router.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
            view.didSelectItem = { item in
                
            }
            view.favoritesTapped = {
                
            }
            view.favoriteTapped = { [weak self] item, completion in
                guard let `self` = self else { return }
                self.interactor.manageFavoriteBook(withId: item.model.id) { result in
                    completion()
                    switch result {
                    case .success(_):
                        self.view.update(withItems: self.volumes.map { VolumeViewModel(model: $0, isFavorite: self.interactor.isBookFavorite(bookId: $0.id)) })
                    case .failure(let error):
                        self.router.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
            view.previewTapped = { [weak self] item in
                self?.router.openURL(item.previewURL)
            }
        }
    }
    var interactor: BooksListInteractorInput!
    var router: BooksListRouterInput!
    
    private var volumes: [Volume] = []
}

// MARK: - BooksListModuleInput

extension BooksListPresenter: BooksListModuleInput {

}
