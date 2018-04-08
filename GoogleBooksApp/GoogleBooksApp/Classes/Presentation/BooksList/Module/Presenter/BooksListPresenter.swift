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
                self?.addNotificationObservers()
            }
            view.searchBooks = { [weak self] query in
                self?.reloadItems(withQuery: query)
            }
            view.itemSelected = { [weak self] item in
                self?.router.openDetails(withViewModel: item)
            }
            view.favoritesTapped = { [weak self] in
                self?.router.openFavorites()
            }
            view.favoriteTapped = { [weak self] item, completion in
                guard let `self` = self else { return }
                self.interactor.manageFavoriteBook(withId: item.model.id) { result in
                    completion()
                    switch result {
                    case .success(_):
                        self.updateViewItems()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification observers
    
    @objc func favoriteBookAdded(notification: Notification) {
        updateViewItems()
    }
    
    @objc func favoriteBookRemoved(notification: Notification) {
        updateViewItems()
    }
    
    // MARK: - Private
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteBookAdded(notification:)),
            name: Notification.Name.favoriteBookAdded,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteBookRemoved(notification:)),
            name: Notification.Name.favoriteBookRemoved,
            object: nil
        )
    }
    
    private func reloadItems(withQuery query: String) {
        interactor.searchBooks(query: query) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let volumes):
                self.volumes = volumes
                self.updateViewItems()
            case .failure(let error):
                self.router.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func updateViewItems() {
        view.update(withItems: volumes.map { VolumeViewModel(model: $0, isFavorite: interactor.isBookFavorite(bookId: $0.id)) })
    }
}

// MARK: - BooksListModuleInput

extension BooksListPresenter: BooksListModuleInput {

}
