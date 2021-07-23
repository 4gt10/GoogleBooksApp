//
//  FavoriteBooksListViewInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

import DTModelStorage

protocol FavoriteBooksListViewInput: class {

    // MARK: - View out

    var output: FavoriteBooksListModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var removeItemTapped: ((_ item: VolumeViewModel) -> Void)? { get set }
    var itemSelected: ((_ item: VolumeViewModel) -> Void)? { get set }
    var previewTapped: ((_ item: VolumeViewModel) -> Void)? { get set }
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
