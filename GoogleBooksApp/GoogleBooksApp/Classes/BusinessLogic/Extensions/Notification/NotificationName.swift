//
//  NotificationName.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    enum Favorite {
        
        static let added = Notification.Name(rawValue: "com.chernov.GoogleBooksApp.notification.Favorite.added")
        static let removed = Notification.Name(rawValue: "com.chernov.GoogleBooksApp.notification.Favorite.removed")
    }
}
