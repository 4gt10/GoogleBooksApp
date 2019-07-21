//
//  URLRoutable.swift
//

import LightRoute
import SafariServices

protocol URLRoutable: Router {
    
}

extension URLRoutable {
    
    func openURL(_ url: URL?) {
        guard
            let transitionHandler = transitionHandler as? UIViewController,
            let url = url else { return }
        transitionHandler.present(SFSafariViewController(url: url), animated: true, completion: nil)
    }
}
