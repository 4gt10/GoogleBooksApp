//
//  BookDetailsAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Swinject
import SwinjectStoryboard

final class BookDetailsAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(BookDetailsInteractor.self) { (r, presenter: BookDetailsPresenter) in
			let interactor = BookDetailsInteractor(
                favoriteBooksService: r.resolve(FavoriteBooksServiceType.self),
                favoriteBooksStorage: r.resolve(FavoriteBooksStorageType.self)
            )

			return interactor
		}

		container.register(BookDetailsRouter.self) { (r, viewController: BookDetailsViewController) in
			let router = BookDetailsRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(BookDetailsPresenter.self) { (r, viewController: BookDetailsViewController) in
			let presenter = BookDetailsPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(BookDetailsInteractor.self, argument: presenter)
			presenter.router = r.resolve(BookDetailsRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(BookDetailsViewController.self) { r, viewController in
            viewController.output = r.resolve(BookDetailsPresenter.self, argument: viewController)
		}
	}
}
