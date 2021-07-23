//
//  BookDetailsViewInput.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//

protocol BookDetailsViewInput: class {

    // MARK: - View out

    var output: BookDetailsModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var previewTapped: (() -> Void)? { get set }
    var favoriteTapped: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func update(withViewModel: VolumeViewModel)
}
