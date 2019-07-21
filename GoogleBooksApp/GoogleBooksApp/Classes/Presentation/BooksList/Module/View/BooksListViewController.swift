//
//  BooksListViewController.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import DTTableViewManager
import DTModelStorage

final class BooksListViewController: UIViewController, BooksListViewInput, DTTableViewManageable {
    
    private enum Constant {
        
        static let emptyStateTitle = R.string.localizable.booksListEmptyStateTitle()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let emptyState = EmptyStateHandler(title: Constant.emptyStateTitle)
    
    // MARK: - View out
    
    var output: BooksListModuleInput?
    var viewIsReady: (() -> Void)?
    var searchBooks: ((_ query: String) -> Void)?
    var itemSelected: ((_ item: VolumeViewModel) -> Void)?
    var favoritesTapped: (() -> Void)?
    var favoriteTapped: ((_ item: VolumeViewModel, _ completion: @escaping () -> Void) -> Void)?
    var previewTapped: ((_ item: VolumeViewModel) -> Void)?
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)?
    
    // MARK: - View in
    
    func setupInitialState() {
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: VolumeCell.self) { cellType, modelType in
            manager.register(cellType)
            manager.heightForCell(withItem: modelType) { _, _ in return UITableView.automaticDimension }
            manager.estimatedHeightForCell(withItem: modelType) { _, _ in return cellType.defaultHeight }
            manager.configure(cellType) { [weak self] cell, model, _ in
                cell.favoriteTappedClosure = { completion in
                    self?.favoriteTapped?(model, completion)
                }
                cell.previewTappedClosure = {
                    self?.previewTapped?(model)
                }
            }
            manager.didSelect(cellType) { [weak self] _, model, indexPath in
                self?.itemSelected?(model)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        if let dataSource = manager.storage as? MemoryStorage {
            dataSourceIsReady?(dataSource)
        }
        emptyState.configure(withScrollableView: tableView)
    }
    
	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    // MARK: - Actions
    
    @IBAction func favoritesButtonTapped(_ sender: UIBarButtonItem) {
        favoritesTapped?()
    }
}

// MARK: - UISearchBarDelegate

extension BooksListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBooks?(searchBar.text ?? "")
    }
}
