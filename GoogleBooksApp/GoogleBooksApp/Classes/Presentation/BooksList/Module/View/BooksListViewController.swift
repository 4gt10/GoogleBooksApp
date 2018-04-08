//
//  BooksListViewController.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import UIKit

final class BooksListViewController: UIViewController {

	// MARK: - Properties

	var output: BooksListViewOutput!

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		output.viewIsReady()
	}
}

// MARK: - BooksListViewInput

extension BooksListViewController: BooksListViewInput {

	func setupInitialState() {
        output.getTestBooks()
	}
}
