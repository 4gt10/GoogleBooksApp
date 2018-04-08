//
//  BooksListAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import Swinject
import SwinjectStoryboard

final class BooksListAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(BooksListInteractor.self) { (r, presenter: BooksListPresenter) in
            let interactor = BooksListInteractor(
                booksListService: r.resolve(BooksListServiceType.self),
                favoriteBooksService: r.resolve(FavoriteBooksServiceType.self),
                favoriteBooksStorage: r.resolve(FavoriteBooksStorageType.self)
            )
			
			return interactor
		}

		container.register(BooksListRouter.self) { (_, viewController: BooksListViewController) in
			let router = BooksListRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(BooksListPresenter.self) { (r, viewController: BooksListViewController) in
			let presenter = BooksListPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(BooksListInteractor.self, argument: presenter)
			presenter.router = r.resolve(BooksListRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(BooksListViewController.self) { r, viewController in
            viewController.hold(r.resolve(BooksListPresenter.self, argument: viewController))
		}
	}
}
