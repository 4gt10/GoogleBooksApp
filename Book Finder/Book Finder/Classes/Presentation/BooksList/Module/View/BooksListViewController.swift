//
//  BooksListViewController.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

import DTTableViewManager
import DTModelStorage
import GoogleMobileAds

final class BooksListViewController: UIViewController, BooksListViewInput, DTTableViewManageable {
    
    private enum Constant {
        
        static let emptyStateTitle = R.string.localizable.booksListEmptyStateTitle()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var bannerView: GADBannerView! = GADBannerView(adSize: kGADAdSizeBanner)
    
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
        
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-4546055219731501/4317411855"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
	}
    
    // MARK: - Actions
    
    @IBAction func favoritesButtonTapped(_ sender: UIBarButtonItem) {
        favoritesTapped?()
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0),
            ])
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}

// MARK: - UISearchBarDelegate

extension BooksListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBooks?(searchBar.text ?? "")
    }
}
