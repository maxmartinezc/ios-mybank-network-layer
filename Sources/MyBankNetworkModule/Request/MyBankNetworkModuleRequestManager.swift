//
//  MyBankNetworkModuleRequestManager.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

@available(macOS 10.15.0, *)
protocol MyBankNetworkModuleRequestManagerProtocol {
    func perform<T: Decodable>(_ request: MyBankNetworkModuleRequestProtocol) async throws -> T
}

@available(macOS 10.15.0, *)
public class MyBankNetworkModuleRequestManager: MyBankNetworkModuleRequestManagerProtocol {
    let apiManager: MyBankNetworkModuleAPIManagerProtocol
    let parser: MyBankNetworkModuleDataParserProtocol
    let accessTokenManager: MyBankNetworkModuleAccessTokenManager
    
    public init() {
        self.apiManager = MyBankNetworkModuleAPIManager()
        self.parser = MyBankNetworkModuleDataParser()
        self.accessTokenManager = MyBankNetworkModuleAccessTokenManager()
    }
    
    public func perform<T: Decodable>(_ request: MyBankNetworkModuleRequestProtocol) async throws -> T {
        
        var authToken = ""
        if request.addAuthorizationToken {
            authToken = try await requestAccessToken()
        }
        
        let data = try await apiManager.perform(request, authToken: authToken)
        
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    internal func requestAccessToken() async throws -> String {
        let data: Data
        
        if accessTokenManager.isHasToken() {
            if !accessTokenManager.isTokenExpired() {
                return accessTokenManager.fetchAccessToken()
            }
            let rToken = accessTokenManager.fetchRefreshToken()
            data = try await apiManager.requestRefreshToken(rToken: rToken)
        } else {
            data = try await apiManager.requestAccessToken()
        }
        
        let token: APIToken = try parser.parse(data: data)
        
        try accessTokenManager.refreshWith(apiToken: token)
        
        return token.bearerAccessToken
    }
}
