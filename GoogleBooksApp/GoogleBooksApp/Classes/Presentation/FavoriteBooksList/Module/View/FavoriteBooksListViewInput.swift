//
//  FavoriteBooksListViewInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

protocol FavoriteBooksListViewInput: class {

    // MARK: - View out

    var output: FavoriteBooksListModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var getFavoriteBooks: (() -> Void)? { get set }
    var removeItemTapped: ((_ item: VolumeViewModel) -> Void)? { get set }
    var itemSelected: ((_ item: VolumeViewModel) -> Void)? { get set }
    var previewTapped: ((_ item: VolumeViewModel) -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func update(withItems: [VolumeViewModel])
}
