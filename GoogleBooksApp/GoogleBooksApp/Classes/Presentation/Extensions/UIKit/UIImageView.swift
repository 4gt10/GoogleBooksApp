//
//  UIImageView.swift
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(withUrl url: URL?, placeholder: UIImage? = nil) {
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
