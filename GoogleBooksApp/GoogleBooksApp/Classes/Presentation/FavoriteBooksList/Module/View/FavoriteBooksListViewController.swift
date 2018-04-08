//
//  FavoriteBooksListViewController.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import UIKit
import DataSources
import DZNEmptyDataSet

final class FavoriteBooksListViewController: UIViewController, FavoriteBooksListViewInput {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dataSource: SectionDataController<VolumeViewModel, TableViewAdapter> = .init(adapter: .init(tableView: tableView))
    
    // MARK: - View out

    var output: FavoriteBooksListModuleInput?
    var viewIsReady: (() -> Void)?
    var getFavoriteBooks: (() -> Void)?
    var removeItemTapped: ((_ item: VolumeViewModel) -> Void)?
    var itemSelected: ((_ item: VolumeViewModel) -> Void)?
    var previewTapped: ((_ item: VolumeViewModel) -> Void)? 

    // MARK: - View in

    func setupInitialState() {
        tableView.estimatedRowHeight = VolumeCell.Constant.defaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getFavoriteBooks?()
    }
    
    func update(withItems items: [VolumeViewModel]) {
        dataSource.update(items: items, updateMode: .everything) { }
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
}

// MARK: - UITableViewDataSource

extension FavoriteBooksListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.volumeCell, for: indexPath)!
        let model = dataSource.item(at: indexPath)
        cell.configure(
            withMode: .favoritesList,
            model: model,
            favoriteTappedClosure: nil,
            previewTappedClosure: { [weak self] in
                self?.previewTapped?(model)
            }
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteBooksListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelected?(dataSource.item(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            removeItemTapped?(dataSource.item(at: indexPath))
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return R.string.localizable.favoriteBooksListDeleteActionTitle()
    }
}

// MARK: - DZNEmptyDataSetSource

extension FavoriteBooksListViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: R.string.localizable.favoriteBooksListEmptyStateTitle())
    }
}
