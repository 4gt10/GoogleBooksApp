//
//  KeychainStorageAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Swinject
import Moya

final class KeychainStorageAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(KeychainStorageType.self) { _ in
            return KeychainStorage()
        }
    }
}
