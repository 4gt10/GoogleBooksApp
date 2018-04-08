//
//  FavoriteBooksListAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import Swinject
import SwinjectStoryboard

final class FavoriteBooksListAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(FavoriteBooksListInteractor.self) { (r, presenter: FavoriteBooksListPresenter) in
			let interactor = FavoriteBooksListInteractor(
                favoriteBooksService: r.resolve(FavoriteBooksServiceType.self),
                favoriteBooksStorage: r.resolve(FavoriteBooksStorageType.self)
            )

			return interactor
		}

		container.register(FavoriteBooksListRouter.self) { (r, viewController: FavoriteBooksListViewController) in
			let router = FavoriteBooksListRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(FavoriteBooksListPresenter.self) { (r, viewController: FavoriteBooksListViewController) in
			let presenter = FavoriteBooksListPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(FavoriteBooksListInteractor.self, argument: presenter)
			presenter.router = r.resolve(FavoriteBooksListRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(FavoriteBooksListViewController.self) { r, viewController in
			viewController.hold(r.resolve(FavoriteBooksListPresenter.self, argument: viewController))
		}
	}
}
