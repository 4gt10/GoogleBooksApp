//
//  FavoriteBooksListPresenter.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Foundation

final class FavoriteBooksListPresenter {

    // MARK: - Properties

    weak var view: FavoriteBooksListViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
                self?.addNotificationObservers()
            }
            view.getFavoriteBooks = { [weak self] in
                self?.reloadItems()
            }
            view.removeItemTapped = { [weak self] item in
                guard let `self` = self else { return }
                self.interactor.removeFavoriteBook(withId: item.model.id) { result in
                    switch result {
                    case .success:
                        if let indexOf = self.volumes.firstIndex(where: { $0.id == item.model.id }) {
                            self.volumes.remove(at: indexOf)
                            self.updateViewItems()
                        }
                    case .failure(let error):
                        self.router.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
            view.itemSelected = { [weak self] item in
                self?.router.openDetails(withViewModel: item)
            }
            view.previewTapped = { [weak self] item in
                self?.router.openURL(item.previewURL)
            }
        }
    }
    var interactor: FavoriteBooksListInteractorInput!
    var router: FavoriteBooksListRouterInput!
    
    private var volumes: [Volume] = []
    
    // MARK: - Notification observers
    
    @objc func favoriteBookRemoved(notification: Notification) {
        reloadItems()
    }
    
    // MARK: - Private
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteBookRemoved(notification:)),
            name: Notification.Name.Favorite.removed,
            object: nil
        )
    }
    
    private func reloadItems() {
        interactor.getFavoriteBooks { [weak self] result in
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
        view.update(withItems: volumes.map { VolumeViewModel(model: $0, isFavorite: true) })
    }
}

// MARK: - FavoriteBooksListModuleInput

extension FavoriteBooksListPresenter: FavoriteBooksListModuleInput {

}
