//
//  UINavigationItem.swift
//  

import UIKit

extension UINavigationItem {
    
    @IBInspectable var localizedKey: String {
        get {
            return ""
        }
        set {
            title = NSLocalizedString(newValue, tableName: R.string.localizable.tableName(), comment: "")
        }
    }
}
