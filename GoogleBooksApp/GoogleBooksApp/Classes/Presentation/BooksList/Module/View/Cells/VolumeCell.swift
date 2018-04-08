//
//  VolumeCell.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import UIKit

enum VolumeCellMode {
    
    case list, favoritesList
}

class VolumeCell: UITableViewCell {
    
    enum Constant {
        
        static let defaultHeight: CGFloat = 111
    }
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton?
    @IBOutlet weak var previewButton: UIButton!
    
    var favoriteTappedClosure: ((_ completion: @escaping () -> Void) -> Void)?
    var previewTappedClosure: (() -> Void)?
    
    // MARK: - Configuration
    
    func configure(
        withMode mode: VolumeCellMode,
        model: VolumeViewModel,
        favoriteTappedClosure: ((_ completion: @escaping () -> Void) -> Void)?,
        previewTappedClosure: (() -> Void)?) {
        thumbnailImageView.setImage(withUrl: model.imageURL)
        nameLabel.text = model.name
        authorsLabel.text = model.authors
        favoriteButton?.setImage(model.isFavorite ? R.image.bookFavoriteOn() : R.image.bookFavoriteOff(), for: .normal)
        self.favoriteTappedClosure = favoriteTappedClosure
        self.previewTappedClosure = previewTappedClosure
        
        switch mode {
        case .list:
            favoriteButton?.isHidden = false
        case .favoritesList:
            favoriteButton?.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped() {
        favoriteButton?.isEnabled = false
        favoriteTappedClosure? { [weak self] in
            self?.favoriteButton?.isEnabled = true
        }
    }
    
    @IBAction func previewButtonTapped() {
        previewTappedClosure?()
    }
}
