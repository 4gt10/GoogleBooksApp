//
//  APIProviderAssembly.swift
//

import Foundation
import Moya
import Swinject

class APIProviderAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MoyaProvider<MultiTarget>.self) { _ in
            let endpointClosure = { (target: MultiTarget) -> Endpoint<MultiTarget> in
                let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
                switch target.target {
                case let target as OAuthAPIRequestSpecification:
                    return defaultEndpoint.adding(newHTTPHeaderFields: target.defaultHeaders).adding(newHTTPHeaderFields: target.oauthTokenHeaders)
                case let target as APIRequestSpecification:
                    return defaultEndpoint.adding(newHTTPHeaderFields: target.defaultHeaders)
                default:
                    fatalError("Unexpected target type")
                }
            }
            var plugins = [PluginType]()
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
            return MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, plugins: plugins)
        }
        container.register(MoyaProvider<MultiTarget>.self) { (_, plugins: [PluginType]) in
            return MoyaProvider<MultiTarget>(plugins: plugins)
        }
    }
}
