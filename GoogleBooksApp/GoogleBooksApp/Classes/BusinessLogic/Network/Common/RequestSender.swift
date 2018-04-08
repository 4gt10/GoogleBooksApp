//
//  RequestSender.swift
//

import Result

protocol RequestSender {
    
    func sendRequest<T: APIRequestSpecification, ResponseDataType: Decodable>(
        requestSpecification: T,
        completion: @escaping (Result<ResponseDataType, APIError>) -> Void
    )
}
