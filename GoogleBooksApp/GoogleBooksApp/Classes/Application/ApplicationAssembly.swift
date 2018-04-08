//
//  ApplicationAssembly.swift
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ApplicationAssembly {
    
    class var assembler: Assembler {
        return Assembler([
            // Storage
            KeychainStorageAssemblyContainer(),
            FavoriteBooksStorageAssemblyContainer(),
            
            // Network
            APIProviderAssembly(),
            
            // Services
            AuthorizationServiceAssemblyContainer(),
            BooksListServiceAssemblyContainer(),
            FavoriteBooksServiceAssemblyContainer(),
            
            // Modules
            BooksListAssemblyContainer()
        ])
    }
}

extension SwinjectStoryboard {
    
    @objc public class func setup() {
        // workaround to fix the issue https://github.com/Swinject/Swinject/issues/218
        Container.loggingFunction = nil
        
        guard let applicationContainer = ApplicationAssembly.assembler.resolver as? Container else { return }
        defaultContainer = applicationContainer
    }
}
