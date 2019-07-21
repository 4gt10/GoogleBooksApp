//
//  BooksListPresenter.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import DTModelStorage

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
                    case .success:
                        self.reloadItem(withId: item.model.id)
                    case .failure(let error):
                        self.router.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
            view.previewTapped = { [weak self] item in
                self?.router.openURL(item.previewURL)
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                self?.dataSource = dataSource
            }
        }
    }
    var interactor: BooksListInteractorInput!
    var router: BooksListRouterInput!
    
    private var dataSource: MemoryStorage!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification observers
    
    @objc func favoriteBookAdded(notification: Notification) {
        guard let id = notification.userInfo?[Notification.Name.Favorite.UserInfoKey.id] as? String else { return }
        reloadItem(withId: id)
    }
    
    @objc func favoriteBookRemoved(notification: Notification) {
        guard let id = notification.userInfo?[Notification.Name.Favorite.UserInfoKey.id] as? String else { return }
        reloadItem(withId: id)
    }
    
    // MARK: - Private
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteBookAdded(notification:)),
            name: Notification.Name.Favorite.added,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoriteBookRemoved(notification:)),
            name: Notification.Name.Favorite.removed,
            object: nil
        )
    }
    
    private func reloadItems(withQuery query: String) {
        interactor.searchBooks(query: query) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let volumes):
                self.dataSource.setItems(volumes.map { VolumeViewModel(
                    model: $0,
                    mode: .list,
                    isFavorite: self.interactor.isBookFavorite(bookId: $0.id)) }
                )
            case .failure(let error):
                self.router.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func reloadItem(withId id: String) {
        guard
            let index = dataSource.items(inSection: 0)?.firstIndex(where: { ($0 as? VolumeViewModel)?.model.id == id }),
            var item = dataSource.item(at: IndexPath(row: index, section: 0)) as? VolumeViewModel else { return }
        item.isFavorite = interactor.isBookFavorite(bookId: id)
        try? dataSource.replaceItem(item, with: item)
    }
}

// MARK: - BooksListModuleInput

extension BooksListPresenter: BooksListModuleInput {

}
