//
//  AuthorizedAPIRequestSpecification.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Moya

protocol OAuthAPIRequestSpecification: APIRequestSpecification {
    
    var oauthTokenHeaders: [String: String] { get }
}

extension OAuthAPIRequestSpecification {
    
    var oauthTokenHeaders: [String: String] {
        return ["Authorization": "Bearer \(KeychainStorage().get(valueForKey: .oauthToken) ?? "")"]
    }
}
