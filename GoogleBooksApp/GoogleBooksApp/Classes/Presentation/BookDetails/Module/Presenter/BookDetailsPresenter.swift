//
//  BookDetailsPresenter.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Foundation

final class BookDetailsPresenter {

    // MARK: - Properties

    weak var view: BookDetailsViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                guard let `self` = self else { return }
                self.view.setupInitialState()
                self.view.update(withViewModel: self.viewModel)
            }
            view.previewTapped = { [weak self] in
                self?.router.openURL(self?.viewModel.previewURL)
            }
            view.favoriteTapped = { [weak self] in
                guard let `self` = self else { return }
                self.interactor.manageFavoriteBook(withId: self.viewModel.model.id, isFavorite: self.viewModel.isFavorite) { result in
                    switch result {
                    case .success:
                        self.viewModel.isFavorite = !self.viewModel.isFavorite
                        self.view.update(withViewModel: self.viewModel)
                    case .failure(let error):
                        self.router.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
        }
    }
    var interactor: BookDetailsInteractorInput!
    var router: BookDetailsRouterInput!
    
    private var viewModel: VolumeViewModel!
}

// MARK: - BookDetailsModuleInput

extension BookDetailsPresenter: BookDetailsModuleInput {

    func configure(withViewModel viewModel: VolumeViewModel) {
        self.viewModel = viewModel
    }
}
