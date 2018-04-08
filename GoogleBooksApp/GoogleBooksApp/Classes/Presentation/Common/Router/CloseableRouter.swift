//
//  CloseableRouter.swift
//  CDEK
//
//  Created by Artur Chernov on 10/02/2018.
//

import LightRoute

protocol CloseableRouter: Router {
    
    func close(animated: Bool)
}

extension CloseableRouter {
    
    func close(animated: Bool) {
        try? transitionHandler.closeCurrentModule(animated: animated).perform()
    }
}
