//
//  VolumeInfo.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

struct VolumeInfo: Decodable {
    
    let title: String
    let authors: [String]
    let description: String?
    let imageLinks: ImageLinks
    let previewLink: String
    
    var previewLinkURL: URL? {
        return URL(string: previewLink)
    }
}
