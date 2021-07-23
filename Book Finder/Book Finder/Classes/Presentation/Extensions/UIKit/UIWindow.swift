//
//  UIWindow.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    class func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = UIApplication.shared.keyWindow?.rootViewController {
            return UIWindow.visibleViewController(from: rootViewController)
        }
        return nil
    }
    
    class func visibleViewController(from viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return UIWindow.visibleViewController(from: navigationController.visibleViewController!)
        } else if let tabBarController = viewController as? UITabBarController {
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController!)
        } else if
            let pageViewController = viewController as? UIPageViewController,
            let currentViewController = pageViewController.viewControllers?.first {
            return UIWindow.visibleViewController(from: currentViewController)
            
        } else {
            if let presentedViewController = viewController.presentedViewController {
                return UIWindow.visibleViewController(from: presentedViewController)
            } else {
                return viewController
            }
        }
    }
}
