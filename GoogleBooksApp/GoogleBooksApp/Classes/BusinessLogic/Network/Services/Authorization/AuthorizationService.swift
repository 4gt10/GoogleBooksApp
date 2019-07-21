//
//  AuthorizationService.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import Foundation
import Result
import KeychainSwift
import OAuthSwift

enum AuthorizationError {
    
    case tokenInvalid
    case tokenExpired
    case unhandled(error: Error)
}

extension AuthorizationError: Error {
    
    var localizedDescription: String {
        switch self {
        case .tokenInvalid: return R.string.localizable.authorizationTokenInvalidErrorMessage()
        case .tokenExpired: return R.string.localizable.authorizationTokenExpiredErrorMessage()
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol AuthorizationServiceType {
    
    func authorize(urlRequest: URLRequest, completion: ((Result<URLRequest, AuthorizationError>) -> Void)?)
    func renewToken(completion: ((Result<Void, AuthorizationError>) -> Void)?)
}

final class AuthorizationService {
    
    private enum Constant {
        
        static let authorizeUrl = "https://accounts.google.com/o/oauth2/auth"
        static let accessTokenUrl = "https://accounts.google.com/o/oauth2/token"
        static let responseType = "code"
        static let scope = "https://www.googleapis.com/auth/books"
        static let state = "books"
    }
    
    private let oauthSwift: OAuth2Swift
    private let keychainStorage: KeychainStorageType?
    private var token: String? {
        return keychainStorage?.get(valueForKey: .oauthToken)
    }
    private var refreshToken: String? {
        return keychainStorage?.get(valueForKey: .oauthRefreshToken)
    }
    private var tokenExpiresDate: Date? {
        guard
            let tokenExpiresDateTimeIntervalString = keychainStorage?.get(valueForKey: .tokenExpiresDate),
            let tokenExpiresDateTimeInterval = TimeInterval(tokenExpiresDateTimeIntervalString) else { return nil }
        return Date(timeIntervalSince1970: tokenExpiresDateTimeInterval)
    }
    
    // MARK: - Init
    
    init(keychainStorage: KeychainStorageType?) {
        self.keychainStorage = keychainStorage
        oauthSwift = OAuth2Swift(
            consumerKey: AppConfiguration.consumerKey,
            consumerSecret: AppConfiguration.consumerSecret,
            authorizeUrl: Constant.authorizeUrl,
            accessTokenUrl: Constant.accessTokenUrl,
            responseType: Constant.responseType
        )
    }
}

extension AuthorizationService: AuthorizationServiceType {
    
    func authorize(urlRequest: URLRequest, completion: ((Result<URLRequest, AuthorizationError>) -> Void)?) {
        renewToken { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                guard let oauthToken = self.keychainStorage?.get(valueForKey: .oauthToken) else {
                    completion?(Result.failure(AuthorizationError.tokenInvalid))
                    return
                }
                completion?(Result.success(self.addOAuthToken(oauthToken, forURLRequest: urlRequest)))
            case .failure(let error):
                guard let visibleViewController = UIWindow.visibleViewController() else {
                    completion?(Result.failure(AuthorizationError.unhandled(error: error)))
                    return
                }
                self.oauthSwift.authorizeURLHandler = SafariURLHandler(viewController: visibleViewController, oauthSwift: self.oauthSwift)
                self.oauthSwift.authorize(
                    withCallbackURL: AppConfiguration.oauthCallbackURL,
                    scope: Constant.scope,
                    state: Constant.state) { result in
                        switch result {
                        case .success(let response):
                            self.keychainStorage?.set(value: response.credential.oauthToken, forKey: .oauthToken)
                            self.keychainStorage?.set(value: response.credential.oauthRefreshToken, forKey: .oauthRefreshToken)
                            self.keychainStorage?.set(value: "\(response.credential.oauthTokenExpiresAt!.timeIntervalSince1970)", forKey: .tokenExpiresDate)
                            completion?(Result.success(self.addOAuthToken(response.credential.oauthToken, forURLRequest: urlRequest)))
                        case .failure(let error):
                            completion?(Result.failure(AuthorizationError.unhandled(error: error)))
                        }
                }
            }
        }
    }
    
    func renewToken(completion: ((Result<Void, AuthorizationError>) -> Void)?) {
        guard token != nil else {
            completion?(Result.failure(AuthorizationError.tokenInvalid))
            return
        }
        guard let refreshToken = refreshToken else {
            completion?(Result.failure(AuthorizationError.tokenInvalid))
            return
        }
        guard let tokenExpiresDate = tokenExpiresDate else {
            completion?(Result.failure(AuthorizationError.tokenExpired))
            return
        }
        guard Date() > tokenExpiresDate else {
            completion?(Result.success(()))
            return
        }
        
        oauthSwift.renewAccessToken(withRefreshToken: refreshToken) { result in
            switch result {
            case .success(let response):
                self.keychainStorage?.set(value: response.credential.oauthToken, forKey: .oauthToken)
                self.keychainStorage?.set(value: response.credential.oauthRefreshToken, forKey: .oauthRefreshToken)
                self.keychainStorage?.set(value: "\(response.credential.oauthTokenExpiresAt!.timeIntervalSince1970)", forKey: .tokenExpiresDate)
                completion?(Result.success(()))
            case .failure(let error):
                completion?(Result.failure(AuthorizationError.unhandled(error: error)))
            }
        }
    }
    
    // MARK: - Private
    
    private func addOAuthToken(_ oauthToken: String, forURLRequest urlRequest: URLRequest) -> URLRequest {
        var authorizedUrlRequest = urlRequest
        authorizedUrlRequest.addValue(
            "Bearer \(oauthToken)",
            forHTTPHeaderField: "Authorization"
        )
        return authorizedUrlRequest
    }
}
