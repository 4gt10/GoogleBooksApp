//
//  FavoriteBooksAPIRequestSpecification.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Moya

enum FavoriteBooksAPIRequestSpecification {
    
    case favoriteBooksList
    case addFavoriteBook(id: String)
    case removeFavoriteBook(id: String)
}

extension FavoriteBooksAPIRequestSpecification: APIRequestSpecification {
    
    var baseURL: URL {
        return URL(string: "\(AppConfiguration.APIURL)mylibrary/bookshelves/0")!
    }
    
    var requiresAuthorization: Bool {
        return true
    }
    
    var path: String {
        switch self {
        case .favoriteBooksList: return "volumes"
        case .addFavoriteBook: return "addVolume"
        case .removeFavoriteBook: return "removeVolume"
            
            
        }
    }
    
    var method: Method {
        switch self {
        case .favoriteBooksList: return .get
        case .addFavoriteBook, .removeFavoriteBook: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .favoriteBooksList:
            return .requestPlain
        case .addFavoriteBook(let id):
            return .requestParameters(parameters: ["volumeId": id], encoding: URLEncoding.default)
        case .removeFavoriteBook(let id):
            return .requestParameters(parameters: ["volumeId": id], encoding: URLEncoding.default)
        }
    }
}
