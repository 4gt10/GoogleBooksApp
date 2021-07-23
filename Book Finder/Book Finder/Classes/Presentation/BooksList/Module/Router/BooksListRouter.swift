//
//  BooksListRouter.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import LightRoute

final class BooksListRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - BooksListRouterInput

extension BooksListRouter: BooksListRouterInput {

    func openFavorites() {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.favoriteBooksList()),
            to: FavoriteBooksListModuleInput.self
        )
        .to(preferred: .navigation(style: .push))
        .perform()
    }
}
