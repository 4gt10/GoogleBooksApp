//
//  UISearchBar.swift
//

import UIKit

extension UISearchBar {
    
    @IBInspectable public var localizedPlaceholderKey: String {
        get {
            return ""
        }
        set {
            placeholder = NSLocalizedString(newValue, tableName: R.string.localizable.tableName(), comment: "")
        }
    }
}
