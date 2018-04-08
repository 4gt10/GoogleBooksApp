//
//  Configuration.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 08/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation

enum AppConfiguration {
    
    static let APIURL = Bundle.main.infoDictionary?["APIURL"] as? String ?? ""
    static let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String ?? ""
    static let consumerKey = Bundle.main.infoDictionary?["ConsumerKey"] as? String ?? ""
    static let consumerSecret = Bundle.main.infoDictionary?["ConsumerSecret"] as? String ?? ""
    static let oauthCallbackURL = Bundle.main.infoDictionary?["OAuthCallbackURL"] as? String ?? ""
}
