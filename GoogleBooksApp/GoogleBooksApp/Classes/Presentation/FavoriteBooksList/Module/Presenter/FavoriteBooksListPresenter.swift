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
            }
            view.getFavoriteBooks = { [weak self] in
                self?.interactor.getFavoriteBooks { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let volumes):
                        self.volumes = volumes
                        self.view.update(withItems: volumes.map { VolumeViewModel(model: $0, isFavorite: true) })
                    case .failure(let error):
                        self.router.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
            view.removeItemTapped = { [weak self] item in
                guard let `self` = self else { return }
                self.interactor.removeFavoriteBook(withId: item.model.id) { result in
                    switch result {
                    case .success:
                        if let indexOf = self.volumes.index(where: { $0.id == item.model.id }) {
                            self.volumes.remove(at: indexOf)
                            self.view.update(withItems: self.volumes.map { VolumeViewModel(model: $0, isFavorite: true) })
                        }
                    case .failure(let error):
                        self.router.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
            view.itemSelected = { item in
                
            }
            view.previewTapped = { [weak self] item in
                self?.router.openURL(item.previewURL)
            }
        }
    }
    var interactor: FavoriteBooksListInteractorInput!
    var router: FavoriteBooksListRouterInput!
    
    private var volumes: [Volume] = []
}

// MARK: - FavoriteBooksListModuleInput

extension FavoriteBooksListPresenter: FavoriteBooksListModuleInput {

}
