//
//  Configuration.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

enum AppConfiguration {
    
    private static let info = Bundle.main.infoDictionary
    static let APIURL = info?["APIURL"] as? String ?? ""
    static let baseURL = info?["BaseURL"] as? String ?? ""
    static let consumerKey = info?["ConsumerKey"] as? String ?? ""
    static let consumerSecret = info?["ConsumerSecret"] as? String ?? ""
    static let oauthCallbackURL = info?["OAuthCallbackURL"] as? String ?? ""
}
