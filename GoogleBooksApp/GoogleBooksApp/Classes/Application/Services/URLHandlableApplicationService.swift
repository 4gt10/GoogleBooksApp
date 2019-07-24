//
//  URLHandlableApplicationService.swift
//  GoogleBooksApp
//
//  Created by Артур Чернов on 7/24/19.
//  Copyright © 2019 Artur Chernov. All rights reserved.
//

import PluggableAppDelegate
import OAuthSwift

final class URLHandlableApplicationService: NSObject, ApplicationService {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        OAuthSwift.handle(url: url)
        return true
    }
}
