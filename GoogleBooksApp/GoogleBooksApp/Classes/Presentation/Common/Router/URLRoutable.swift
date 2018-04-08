//
//  URLRoutable.swift
//

import LightRoute
import SafariServices

protocol URLRoutable: Router {
    
}

extension URLRoutable {
    
    func openURL(_ url: URL?) {
        guard let transitionHandler = transitionHandler as? UIViewController else {
            debugPrint("Transition handler should be UIViewController.")
            return
        }
        if let url = url {
            transitionHandler.present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
}
