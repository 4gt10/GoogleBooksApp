//
//  OAuthAPIProvider.swift
//

import Moya
import Result

class OAuthAPIProvider {
    
    private enum Constant {
        
        static let authorizationHeaderKey = "Authorization"
        static let oauthPasswordGrantType = "password"
        static let oauthTokenPath = "/oauth/token"
    }
    
    private var provider: MoyaProvider<MultiTarget>?
    private let authService: AuthorizationServiceType?
    private let responseDecoder: JSONDecoder
    
    // MARK: - Init
    
    init(
        authService: AuthorizationServiceType?,
        plugins: [PluginType] = [],
        defaultApiKey: String? = nil,
        defaultHeaders: [String: String] = [:],
        responseDecoder: JSONDecoder = JSONDecoder()) {
        self.authService = authService
        self.responseDecoder = responseDecoder
        
        // Append default headers
        let endpointClosure = { (target: MultiTarget) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            var additionalHeaders = defaultHeaders
            switch target.target {
            case let target as APIRequestSpecification:
                // If target doesn't require auth token, provide default api key
                if
                    let defaultApiKey = defaultApiKey,
                    !target.requiresAuthorization {
                    additionalHeaders[Constant.authorizationHeaderKey] = defaultApiKey
                }
            default:
                break
            }
            target.headers?.forEach { additionalHeaders[$0] = $1 }
            return defaultEndpoint.adding(newHTTPHeaderFields: additionalHeaders)
        }
        
        // Authorize requests if needed
        let requestClosure = { [weak self] (endpoint: Endpoint, completion: @escaping (Result<URLRequest, MoyaError>) -> Void) in
            if let urlRequest = try? endpoint.urlRequest() {
                if
                    let headers = endpoint.httpHeaderFields,
                    headers[Constant.authorizationHeaderKey] != nil {
                    // Unauthorized requests
                    completion(.success(urlRequest))
                } else {
                    // Authorized requests
                    self?.authService?.authorize(urlRequest: urlRequest) { result in
                        switch result {
                        case .success(let authorizedUrlRequest):
                            completion(.success(authorizedUrlRequest))
                        case .failure(let error):
                            completion(.failure(.underlying(error, nil)))
                        }
                    }
                }
            }
        }
        
        self.provider = MoyaProvider<MultiTarget>(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            plugins: plugins
        )
    }
    
    func sendRequest<T: APIRequestSpecification, ResponseDataType: Decodable>(
        requestSpecification: T,
        completion: @escaping (Result<ResponseDataType, APIError>) -> Void) {
        guard let provider = provider else { return }
        provider.request(MultiTarget(requestSpecification)) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                do {
                    completion(.success(try response.map(ResponseDataType.self, using: self.responseDecoder)))
                } catch let error {
                    completion(.failure(.fromMoyaError(.objectMapping(error, response))))
                }
            case .failure(let error):
                completion(.failure(.fromMoyaError(error)))
            }
        }
    }
    
    func sendRequest<T: APIRequestSpecification>(
        requestSpecification: T,
        completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let provider = provider else { return }
        provider.request(MultiTarget(requestSpecification)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(.fromMoyaError(error)))
            }
        }
    }
}
