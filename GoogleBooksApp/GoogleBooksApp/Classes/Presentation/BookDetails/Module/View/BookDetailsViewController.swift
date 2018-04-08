//
//  BookDetailsViewController.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import UIKit

final class BookDetailsViewController: UIViewController, BookDetailsViewInput {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - View out

    var output: BookDetailsModuleInput? 
    var viewIsReady: (() -> Void)?
    var previewTapped: (() -> Void)?
    var favoriteTapped: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        
    }
    
    func update(withViewModel viewModel: VolumeViewModel) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: viewModel.isFavorite ? R.image.bookFavoriteOn() : R.image.bookFavoriteOff(),
            style: .done,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        thumbnailImageView.setImage(withUrl: viewModel.imageURL)
        nameLabel.text = viewModel.name
        authorsLabel.text = viewModel.authors
        descriptionLabel.text = viewModel.description
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    // MARK: - Actions
    
    @IBAction func previewButtonTapped() {
        previewTapped?()
    }
    
    @objc func favoriteButtonTapped() {
        favoriteTapped?()
    }
}
