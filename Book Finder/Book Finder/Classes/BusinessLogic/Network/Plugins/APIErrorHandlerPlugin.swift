//
//  APIErrorHandlerPlugin.swift
//

import Moya
import Result

final class APIErrorHandlerPlugin {}

extension APIErrorHandlerPlugin: PluginType {
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            do {
                // Success (code is 2xx)
                _ = try response.filterSuccessfulStatusCodes()
                return result
            } catch let error {
                return Result(error: MoyaError.underlying(APIError.unhandled(error: error), response))
            }
        case .failure:
            // Internal error (server didn't receive request and didn't send response)
            return Result(error: MoyaError.underlying(APIError.noInternetConnection, nil))
        }
    }
}
