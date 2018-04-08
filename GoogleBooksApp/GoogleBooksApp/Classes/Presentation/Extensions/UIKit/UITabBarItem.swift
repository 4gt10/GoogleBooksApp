//
//  UITabBarItem.swift
//

import UIKit

extension UITabBarItem {
    
    @IBInspectable var localizedKey: String {
        get {
            return ""
        }
        set {
            title = NSLocalizedString(newValue, tableName: R.string.localizable.tableName(), comment: "")
        }
    }
}
