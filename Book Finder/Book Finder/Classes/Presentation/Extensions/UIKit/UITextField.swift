//
//  UITextField.swift
//

import UIKit

extension UITextField {

    @IBInspectable public var localizedPlaceholderKey: String {
        get {
            return ""
        }
        set {
            placeholder = NSLocalizedString(newValue, tableName: R.string.localizable.tableName(), comment: "")
        }
    }

    @IBInspectable public var localizedTextKey: String {
        get {
            return ""
        }
        set {
            text = NSLocalizedString(newValue, tableName: R.string.localizable.tableName(), comment: "")
        }
    }
    
    @IBInspectable var aPlaceholderColor: UIColor? {
        get {
            return attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
        set {
            guard
                let placeholder = placeholder,
                let placeholderColor = newValue else { return }
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
}
