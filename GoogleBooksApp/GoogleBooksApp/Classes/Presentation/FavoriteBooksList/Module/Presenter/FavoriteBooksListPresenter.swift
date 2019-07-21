//
//  FavoriteBooksListPresenter.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import DTModelStorage

final class FavoriteBooksListPresenter {

    // MARK: - Properties

    weak var view: FavoriteBooksListViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
                self?.addNotificationObservers()
                self?.reloadItems()
            }
            view.removeItemTapped = { [weak self] item in
                guard let `self` = self else { return }
                self.interactor.removeFavoriteBook(withId: item.model.id) { result in
                    switch result {
                    case .success:
                        self.removeItem(withId: item.model.id)
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
            view.dataSourceIsReady = { [weak self] dataSource in
                self?.dataSource = dataSource
            }
        }
    }
    var interactor: FavoriteBooksListInteractorInput!
    var router: FavoriteBooksListRouterInput!
    
    private var dataSource: MemoryStorage!
    
    // MARK: - Notification observers
    
    @objc func favoriteBookRemoved(notification: Notification) {
        guard let id = notification.userInfo?[Notification.Name.Favorite.UserInfoKey.id] as? String else { return }
        removeItem(withId: id)
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
                self.dataSource.setItems(volumes.map { VolumeViewModel(model: $0, mode: .favoritesList, isFavorite: true) })
            case .failure(let error):
                self.router.showAlert(withMessage: error.localizedDescription)
            }
        }
    }
    
    private func removeItem(withId id: String) {
        guard
            let index = dataSource.items(inSection: 0)?.firstIndex(where: { ($0 as? VolumeViewModel)?.model.id == id }),
            let item = dataSource.item(at: IndexPath(row: index, section: 0)) as? VolumeViewModel else { return }
        try? dataSource.removeItem(item)
    }
}

// MARK: - FavoriteBooksListModuleInput

extension FavoriteBooksListPresenter: FavoriteBooksListModuleInput {

}
