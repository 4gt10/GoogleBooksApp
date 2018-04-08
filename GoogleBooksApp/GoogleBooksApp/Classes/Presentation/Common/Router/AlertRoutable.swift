//
//  AlertRoutable.swift
//  CDEK
//
//  Created by Artur Chernov on 06/02/2018.
//

import LightRoute

protocol AlertRoutable: Router {
    
}

extension TransitionHandler where Self: UIViewController {
    
    func showAlert(withMessage message: String, title: String? = nil, closeHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.commonOk(), style: .default) { _ in
            closeHandler?()
        })

        present(alert, animated: true, completion: nil)
    }
}

extension AlertRoutable {
    
    func showAlert(withMessage message: String, title: String? = nil, closeHandler: (() -> Void)? = nil) {
        guard let transitionHandler = transitionHandler as? UIViewController else {
            debugPrint("Transition handler should be UIViewController.")
            return
        }
        transitionHandler.showAlert(withMessage: message, title: title, closeHandler: closeHandler)
    }
}
