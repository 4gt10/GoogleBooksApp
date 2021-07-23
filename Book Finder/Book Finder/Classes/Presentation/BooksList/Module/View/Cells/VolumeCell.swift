//
//  VolumeCell.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import DTModelStorage

class VolumeCell: UITableViewCell {
    
    static let defaultHeight: CGFloat = 111
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton?
    @IBOutlet weak var previewButton: UIButton!
    
    var favoriteTappedClosure: ((_ completion: @escaping () -> Void) -> Void)?
    var previewTappedClosure: (() -> Void)?
    
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

extension VolumeCell: ModelTransfer {
    
    func update(with model: VolumeViewModel) {
        thumbnailImageView.setImage(withUrl: model.imageURL)
        nameLabel.text = model.name
        authorsLabel.text = model.authors
        favoriteButton?.setImage(model.isFavorite ? R.image.bookFavoriteOn() : R.image.bookFavoriteOff(), for: .normal)
        switch model.mode {
        case .list:
            favoriteButton?.isHidden = false
        case .favoritesList:
            favoriteButton?.isHidden = true
        }
    }
}
