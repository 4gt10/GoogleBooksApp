//
//  UIButton.swift
//

import UIKit

extension UIButton {
    
    @IBInspectable public var localizedTitleKey: String {
        get {
            return ""
        }
        set {
            setTitle(NSLocalizedString(newValue, tableName: R.string.localizable.tableName(), comment: ""), for: .normal)
        }
    }
}
