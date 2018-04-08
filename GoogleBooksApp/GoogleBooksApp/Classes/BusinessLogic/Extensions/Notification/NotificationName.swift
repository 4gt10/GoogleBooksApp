//
//  NotificationName.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let favoriteBookAdded = Notification.Name(rawValue: "com.chernov.GoogleBooksApp.notification.favoriteBookAdded")
    static let favoriteBookRemoved = Notification.Name(rawValue: "com.chernov.GoogleBooksApp.notification.favoriteBookRemoved")
}
