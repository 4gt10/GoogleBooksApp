//
//  Volume.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

struct Volume: Decodable {
    
    let id: String
    let volumeInfo: VolumeInfo
}
