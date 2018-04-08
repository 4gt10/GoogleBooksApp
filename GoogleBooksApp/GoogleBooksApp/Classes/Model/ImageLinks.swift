//
//  ImageLinks.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

struct ImageLinks: Decodable {
    
    let thumbnail: String
    
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
}
