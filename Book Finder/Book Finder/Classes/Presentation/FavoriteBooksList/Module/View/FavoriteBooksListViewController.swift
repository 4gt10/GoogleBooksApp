//
//  FavoriteBooksListViewController.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import DTTableViewManager
import DTModelStorage
import GoogleMobileAds

final class FavoriteBooksListViewController: UIViewController, FavoriteBooksListViewInput, DTTableViewManageable {
    
    lazy var bannerView: GADBannerView! = GADBannerView(adSize: kGADAdSizeBanner)
    
    private enum Constant {
        
        static let emptyStateTitle = R.string.localizable.favoriteBooksListEmptyStateTitle()
        static let deleteItemTitle = R.string.localizable.favoriteBooksListDeleteActionTitle()
    }

    @IBOutlet weak var tableView: UITableView!
    
    private let emptyState = EmptyStateHandler(title: Constant.emptyStateTitle)
    
    // MARK: - View out

    var output: FavoriteBooksListModuleInput?
    var viewIsReady: (() -> Void)?
    var removeItemTapped: ((_ item: VolumeViewModel) -> Void)?
    var itemSelected: ((_ item: VolumeViewModel) -> Void)?
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
                cell.previewTappedClosure = {
                    self?.previewTapped?(model)
                }
            }
            manager.canEditCell(withItem: modelType) { _, _ -> Bool in
                return true
            }
            manager.commitEditingStyle(for: cellType) { [weak self] editingStyle, _, model, _ in
                switch editingStyle {
                case .delete: self?.removeItemTapped?(model)
                default: break
                }
            }
            manager.titleForDeleteConfirmationButton(in: cellType) { _, _, _ -> String? in
                return Constant.deleteItemTitle
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
