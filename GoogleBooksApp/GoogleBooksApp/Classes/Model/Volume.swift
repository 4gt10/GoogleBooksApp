//
//  Volume.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

struct VolumeInfoImageLinks: Decodable {
    
    var thumbnail: String
    
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
}

struct VolumeInfo: Decodable {
    
    var title: String
    var authors: [String]
    var description: String
    var imageLinks: VolumeInfoImageLinks
    var previewLink: String
    
    var previewLinkURL: URL? {
        return URL(string: previewLink)
    }
}

struct Volume: Decodable {
    
    var id: String
    var volumeInfo: VolumeInfo
}

struct VolumesList: Decodable {
    
    var items: [Volume]
}
