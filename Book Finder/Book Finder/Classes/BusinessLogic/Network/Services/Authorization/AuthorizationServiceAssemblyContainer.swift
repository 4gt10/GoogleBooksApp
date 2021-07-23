//
//  AuthorizationServiceAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Swinject

final class AuthorizationServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthorizationServiceType.self) { r in
            return AuthorizationService(keychainStorage: r.resolve(KeychainStorageType.self))
        }
    }
}
