//
//  APIRequestSpecification.swift
//

import Foundation
import Moya

protocol APIRequestSpecification: TargetType {
    
    var defaultHeaders: [String: String] { get }
}

extension APIRequestSpecification {
    
    var baseURL: URL {
        return URL(string: AppConfiguration.APIURL)!
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var defaultHeaders: [String: String] {
        return [:]
    }
}
