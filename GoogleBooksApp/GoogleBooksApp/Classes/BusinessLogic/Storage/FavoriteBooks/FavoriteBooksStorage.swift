//
//  FavoriteBooksStorage.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

protocol FavoriteBooksStorageType {
    
    func addFavoriteBook(withId: String)
    func removeFavoriteBook(withId: String)
    func isBookFavorite(bookId: String) -> Bool
}

final class FavoriteBooksStorage {
    
    private enum Constant {
        
        static let favoriteBooksIdsKey = "favoriteBooksIds"
    }
    
    init() {
        let defaults = UserDefaults.standard
        guard (defaults.array(forKey: Constant.favoriteBooksIdsKey) as? [String]) != nil else {
            defaults.set([String](), forKey: Constant.favoriteBooksIdsKey)
            defaults.synchronize()
            return
        }
    }
}

extension FavoriteBooksStorage: FavoriteBooksStorageType {
    
    func addFavoriteBook(withId id: String) {
        let defaults = UserDefaults.standard
        guard var favoriteBooksIds = defaults.array(forKey: Constant.favoriteBooksIdsKey) as? [String] else { return }
        if !favoriteBooksIds.contains(id) {
            favoriteBooksIds.append(id)
            defaults.set(favoriteBooksIds, forKey: Constant.favoriteBooksIdsKey)
            defaults.synchronize()
            
            NotificationCenter.default.post(name: Notification.Name.favoriteBookAdded, object: nil)
        }
    }
    
    func removeFavoriteBook(withId id: String) {
        let defaults = UserDefaults.standard
        guard var favoriteBooksIds = defaults.array(forKey: Constant.favoriteBooksIdsKey) as? [String] else { return }
        if favoriteBooksIds.contains(id) {
            favoriteBooksIds.remove(at: favoriteBooksIds.firstIndex(of: id)!)
            defaults.set(favoriteBooksIds, forKey: Constant.favoriteBooksIdsKey)
            defaults.synchronize()
            
            NotificationCenter.default.post(name: Notification.Name.favoriteBookRemoved, object: nil)
        }
    }
    
    func isBookFavorite(bookId: String) -> Bool {
        let defaults = UserDefaults.standard
        guard let favoriteBooksIds = defaults.array(forKey: Constant.favoriteBooksIdsKey) as? [String] else { return false }
        return favoriteBooksIds.contains(bookId)
    }
}
