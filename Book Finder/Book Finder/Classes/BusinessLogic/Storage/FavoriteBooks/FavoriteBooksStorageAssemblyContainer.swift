//
//  FavoriteBooksStorageAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Swinject

final class FavoriteBooksStorageAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(FavoriteBooksStorageType.self) { _ in
            return FavoriteBooksStorage()
        }
    }
}
