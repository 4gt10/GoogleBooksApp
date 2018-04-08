//
//  BooksListServiceAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Swinject
import Moya

final class BooksListServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(BooksListServiceType.self) { r in
            let provider = r.resolve(MoyaProvider<MultiTarget>.self)
            let requestSender = APIRequestSender(provider: provider)
            let authorizationService = r.resolve(AuthorizationServiceType.self)
            return BooksListService(requestSender: requestSender, authorizationService: authorizationService)
        }
    }
}
