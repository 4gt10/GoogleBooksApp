//
//  ActivityIndicatorRenderer.swift
//

import NVActivityIndicatorView

private enum ActivityIndicatorRendererConstant {
    
    static let size = CGSize(width: 30, height: 30)
    static let threshold = 300
}

protocol ActivityIndicatorRenderer {
    
    func showProgress()
    func hideProgress()
}

extension ActivityIndicatorRenderer where Self: UIViewController {
    
    func showProgress() {
        view.isUserInteractionEnabled = false
        let activityData = ActivityData(
            size: ActivityIndicatorRendererConstant.size,
            type: NVActivityIndicatorType.circleStrokeSpin,
            displayTimeThreshold: ActivityIndicatorRendererConstant.threshold
        )
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    func hideProgress() {
        view.isUserInteractionEnabled = true
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
