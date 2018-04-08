//
//  RequestSender.swift
//

import Result

protocol RequestSender {
    
    func sendRequest<T: APIRequestSpecification, ResponseDataType: Decodable>(
        requestSpecification: T,
        completion: @escaping (Result<ResponseDataType, APIError>) -> Void
    )
    
    func sendRequest<T: APIRequestSpecification>(
        requestSpecification: T,
        completion: @escaping (Result<Void, APIError>) -> Void
    )
}
