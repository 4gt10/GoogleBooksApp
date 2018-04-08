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

extension ActivityIndicatorRenderer {
    
    func showProgress() {
        let activityData = ActivityData(
            size: ActivityIndicatorRendererConstant.size,
            type: NVActivityIndicatorType.circleStrokeSpin,
            displayTimeThreshold: ActivityIndicatorRendererConstant.threshold
        )
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func hideProgress() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}
