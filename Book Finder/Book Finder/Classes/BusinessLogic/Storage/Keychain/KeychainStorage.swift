//
//  KeychainStorage.swift
//

import KeychainSwift

enum KeychainStorageKey: String {
    
    case oauthToken
    case oauthRefreshToken
    case tokenExpiresDate
}

protocol KeychainStorageType {
    
    func set(value: String, forKey key: KeychainStorageKey)
    func get(valueForKey key: KeychainStorageKey) -> String?
    func remove(valueForKey key: KeychainStorageKey)
    func clear()
}

final class KeychainStorage: KeychainStorageType {

    func set(value: String, forKey key: KeychainStorageKey) {
        KeychainSwift().set(value, forKey: key.rawValue)
    }

    func get(valueForKey key: KeychainStorageKey) -> String? {
        return KeychainSwift().get(key.rawValue)
    }

    func remove(valueForKey key: KeychainStorageKey) {
        KeychainSwift().delete(key.rawValue)
    }

    func clear() {
        KeychainSwift().clear()
    }
}
