//
//  APIRequestSpecification.swift
//

import Moya

public protocol APIRequestSpecification: TargetType {
    
    var requiresAuthorization: Bool { get }
}

public extension APIRequestSpecification {
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return nil
    }
}
