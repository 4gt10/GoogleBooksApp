//
//  BooksListAPIRequestSpecification.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Moya

enum BooksListAPIRequestSpecification {
    
    case searchBooks(query: String)
}

extension BooksListAPIRequestSpecification: APIRequestSpecification {
    
    var requiresAuthorization: Bool {
        return true
    }
    
    var baseURL: URL {
         return URL(string: AppConfiguration.APIURL)!
    }
    
    var path: String {
        switch self {
        case .searchBooks: return "volumes"
        }
    }
    
    var method: Method {
        switch self {
        case .searchBooks: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .searchBooks(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.default)
        }
    }
}
