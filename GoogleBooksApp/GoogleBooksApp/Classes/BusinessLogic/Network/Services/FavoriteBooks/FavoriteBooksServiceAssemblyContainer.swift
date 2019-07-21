//
//  FavoriteBooksServiceAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Swinject
import Moya

final class FavoriteBooksServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(FavoriteBooksServiceType.self) { r in
            return FavoriteBooksService(apiProvider: r.resolve(OAuthAPIProvider.self))
        }
    }
}
