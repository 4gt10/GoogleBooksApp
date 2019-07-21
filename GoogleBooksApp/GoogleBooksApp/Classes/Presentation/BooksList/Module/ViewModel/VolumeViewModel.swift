//
//  VolumeViewModel.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation
import DataSources

struct VolumeViewModel {
    
    enum Mode {
        
        case list, favoritesList
    }
    
    let model: Volume
    
    private let id: String
    let imageURL: URL?
    let name: String?
    let authors: String?
    let description: String?
    let previewURL: URL?
    let mode: Mode
    var isFavorite: Bool
    
    init(model: Volume, mode: Mode, isFavorite: Bool) {
        self.model = model
        
        self.id = model.id
        self.imageURL = model.volumeInfo.imageLinks?.thumbnailURL
        self.name = model.volumeInfo.title
        self.authors = model.volumeInfo.authors?.joined(separator: ", ")
        self.description = model.volumeInfo.description
        self.previewURL = model.volumeInfo.previewLinkURL
        self.mode = mode
        self.isFavorite = isFavorite
    }
}

extension VolumeViewModel: Diffable {
    
    var diffIdentifier: AnyHashable { return id }
}

extension VolumeViewModel: Equatable {
    
    static func==(lhs: VolumeViewModel, rhs: VolumeViewModel) -> Bool {
        return lhs.diffIdentifier == rhs.diffIdentifier
    }
}
