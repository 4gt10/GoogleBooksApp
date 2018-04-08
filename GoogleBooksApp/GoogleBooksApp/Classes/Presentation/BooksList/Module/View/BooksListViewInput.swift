//
//  BooksListViewInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//

protocol BooksListViewInput: class, ActivityIndicatorRenderer {

    // MARK: - View out
    
    var viewIsReady: (() -> Void)? { get set }
    var searchBooks: ((_ query: String) -> Void)? { get set }
    var didSelectItem: ((_ item: VolumeViewModel) -> Void)? { get set }
    var favoritesTapped: (() -> Void)? { get set }
    var favoriteTapped: ((_ item: VolumeViewModel, _ completion: @escaping () -> Void) -> Void)? { get set }
    var previewTapped: ((_ item: VolumeViewModel) -> Void)? { get set }
    
    // MARK: - View in
    
    func setupInitialState()
    func update(withItems: [VolumeViewModel])
}
