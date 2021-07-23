//
//  AlertRoutable.swift
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
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        transitionHandler.showAlert(withMessage: message, title: title, closeHandler: closeHandler)
    }
}
