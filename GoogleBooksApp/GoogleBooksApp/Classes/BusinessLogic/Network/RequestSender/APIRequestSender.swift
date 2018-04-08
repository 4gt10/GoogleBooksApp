//
//  APIRequestSender.swift
//

import Foundation
import Moya
import Result

protocol APIErrorType: Error {
    
}

enum APIError {
    
    case mappingError
    case unhandled(error: Error)
}

extension APIError: APIErrorType {
    
    var localizedDescription: String {
        switch self {
        case .mappingError: return R.string.localizable.apiMappingErrorMessage()
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class APIRequestSender: RequestSender {
    
    private var provider: MoyaProvider<MultiTarget>?
    
    init(provider: MoyaProvider<MultiTarget>?) {
        self.provider = provider
    }
    
    func sendRequest<T: APIRequestSpecification, ResponseDataType: Decodable>(
        requestSpecification: T,
        completion: @escaping (Result<ResponseDataType, APIError>) -> Void) {
        guard let provider = provider else { return }
        provider.request(MultiTarget(requestSpecification)) { result in
            switch result {
            case let .success(response):
                do {
                    completion(Result.success(try response.map(ResponseDataType.self)))
                } catch _ {
                    completion(Result.failure(APIError.mappingError))
                }
            case let .failure(error):
                completion(Result.failure(APIError.unhandled(error: error)))
            }
        }
    }
}

