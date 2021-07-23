//
//  UILabel.swift
//

import UIKit

extension UILabel {
    
    @IBInspectable public var localizedTextKey: String {
        get {
            return ""
        }
        set {
            text = NSLocalizedString(newValue, tableName: R.string.localizable.tableName(), comment: "")
        }
    }
}
