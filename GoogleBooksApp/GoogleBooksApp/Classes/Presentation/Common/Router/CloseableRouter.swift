//
//  CloseableRouter.swift
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
