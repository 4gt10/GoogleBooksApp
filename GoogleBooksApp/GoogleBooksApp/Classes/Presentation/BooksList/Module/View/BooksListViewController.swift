//
//  BooksListViewController.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import UIKit
import DataSources
import DZNEmptyDataSet

final class BooksListViewController: UIViewController, BooksListViewInput {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource: SectionDataController<VolumeViewModel, TableViewAdapter> = .init(adapter: .init(tableView: tableView))
    
    // MARK: - View out
    
    var viewIsReady: (() -> Void)?
    var searchBooks: ((_ query: String) -> Void)?
    var didSelectItem: ((_ item: VolumeViewModel) -> Void)?
    var favoritesTapped: (() -> Void)?
    var favoriteTapped: ((_ item: VolumeViewModel, _ completion: @escaping () -> Void) -> Void)?
    var previewTapped: ((_ item: VolumeViewModel) -> Void)?
    
    // MARK: - View in
    
    func setupInitialState() {
        tableView.estimatedRowHeight = VolumeCell.Constant.defaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.emptyDataSetSource = self;
    }
    
    func update(withItems items: [VolumeViewModel]) {
        dataSource.update(items: items, updateMode: .everything) { }
    }
    
    // MARK: - Holder
    
    private var holder = [Any?]()
    
    func hold(_ item: Any?) {
        holder.append(item)
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

// MARK: - UITableViewDataSource

extension BooksListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.volumeCell, for: indexPath)!
        let model = dataSource.item(at: indexPath)
        cell.configure(
            withModel: model,
            favoriteTappedClosure: { [weak self] completion in
                self?.favoriteTapped?(model, completion)
            },
            previewTappedClosure: { [weak self] in
                self?.previewTapped?(model)
            }
        )
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension BooksListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBooks?(searchBar.text ?? "")
    }
}

// MARK: - UITableViewDelegate

extension BooksListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem?(dataSource.item(at: indexPath))
    }
}

// MARK: - DZNEmptyDataSetSource

extension BooksListViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: R.string.localizable.booksListEmptyStateTitle())
    }
}
