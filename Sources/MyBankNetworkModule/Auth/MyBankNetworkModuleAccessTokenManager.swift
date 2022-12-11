//
//  MyBankNetworkModuleAccessTokenManager.swift
//  
//
//  Created by Max Martinez Cartagena on 10-12-22.
//

import Foundation

protocol MyBankNetworkModuleAccessTokenManagerProtocol {
    func isHasToken() -> Bool
    func isTokenExpired() -> Bool
    func fetchAccessToken() -> String
    func fetchRefreshToken() -> String
    func refreshWith(apiToken: APIToken) throws
}

class MyBankNetworkModuleAccessTokenManager {
    private let userDefaults: UserDefaults
    private var accessToken: String?
    private var expiresAt = Date()
    private var refreshToken: String?
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        update()
    }
}

// MARK: - MyBankNetworkModuleAccessTokenManagerProtocol
extension MyBankNetworkModuleAccessTokenManager: MyBankNetworkModuleAccessTokenManagerProtocol {
    func isHasToken() -> Bool {
        update()
        return accessToken != nil
    }
    
    func isTokenExpired() -> Bool {
        update()
        return !(expiresAt.compare(Date()) == .orderedDescending)
    }
    
    func fetchAccessToken() -> String {
        guard let token = accessToken else {
            return ""
        }
        return token
    }
    
    func fetchRefreshToken() -> String {
        guard let token = refreshToken else {
            return ""
        }
        return token
    }
    
    func refreshWith(apiToken: APIToken) throws {
        save(token: apiToken)
        self.expiresAt = apiToken.expiresAt
        self.accessToken = apiToken.bearerAccessToken
        self.refreshToken = apiToken.refreshToken
    }
}

// MARK: - Token Expiration
private extension MyBankNetworkModuleAccessTokenManager {
    func save(token: APIToken) {
        userDefaults.set(token.expiresAt.timeIntervalSince1970, forKey: MyBankNetworkModuleAPIConstants.expiresAt)
        userDefaults.set(token.bearerAccessToken, forKey: MyBankNetworkModuleAPIConstants.bearerAccessToken)
        userDefaults.set(token.refreshToken, forKey: MyBankNetworkModuleAPIConstants.refreshToken)
    }
    
    func getExpirationDate() -> Date {
        Date(timeIntervalSince1970: userDefaults.double(forKey: MyBankNetworkModuleAPIConstants.expiresAt))
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: MyBankNetworkModuleAPIConstants.bearerAccessToken)
    }
    
    func getRefreshToken() -> String?{
        userDefaults.string(forKey: MyBankNetworkModuleAPIConstants.refreshToken)
    }
    
    func update() {
        accessToken = getToken()
        expiresAt = getExpirationDate()
        refreshToken = getRefreshToken()
    }
}
