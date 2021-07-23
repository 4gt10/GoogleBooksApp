//
//  OAuthAPIProviderAssemblyContainer.swift
//  GoogleBooksApp
//
//  Created by Артур Чернов on 7/14/19.
//  Copyright © 2019 Artur Chernov. All rights reserved.
//

import Swinject
import Moya

final class OAuthAPIProviderAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        var plugins = [PluginType]()
        plugins.append(APIErrorHandlerPlugin())
        #if DEBUG
        plugins.append(
            NetworkLoggerPlugin(verbose: true, cURL: true, responseDataFormatter: { data in
                do {
                    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
                    let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
                    return prettyData
                } catch {
                    return data
                }
            })
        )
        #endif
        container.register(OAuthAPIProvider.self) { r in
            return OAuthAPIProvider(
                authService: r.resolve(AuthorizationServiceType.self),
                plugins: plugins
            )
        }
    }
}
