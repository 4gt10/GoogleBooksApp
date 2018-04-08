//
//  UIImageView.swift
//  CDEK
//
//  Created by Elizaveta on 02/02/2018.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(withUrl url: URL?, placeholder: UIImage? = nil) {
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
