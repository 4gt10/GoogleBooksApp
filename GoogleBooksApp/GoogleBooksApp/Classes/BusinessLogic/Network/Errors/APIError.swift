//
//  APIError.swift
//  RoboCredit
//
//  Created by 4gt10 on 28.04.2018.
//  Copyright © 2018 Zaymer. All rights reserved.
//

import Moya

public enum APIError: Error {
    
    case noInternetConnection
    case authentificationError
    case mappingError(error: Error, response: Response)
    case unhandled(error: Error)
    
    static func fromMoyaError(_ moyaError: MoyaError) -> APIError {
        switch moyaError {
        case .underlying(let error, _):
            // is from APIErrorHandlerPlugin?
            guard let apiError = error as? APIError else {
                switch (error as NSError).code {
                case NSURLErrorNotConnectedToInternet:
                    return .noInternetConnection
                case NSURLErrorUserAuthenticationRequired, 401, 403:
                    return .authentificationError
                default:
                    return .unhandled(error: error)
                }
            }
            return apiError
        case let .objectMapping(error, response):
            return mappingError(error: error, response: response)
        default:
            return .unhandled(error: moyaError)
        }
    }
}

extension APIError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return ""
        case .authentificationError:
            return ""
        case .mappingError(let error, _):
            return error.localizedDescription
        case .unhandled(let error):
            return error.localizedDescription
        }
    }
}
