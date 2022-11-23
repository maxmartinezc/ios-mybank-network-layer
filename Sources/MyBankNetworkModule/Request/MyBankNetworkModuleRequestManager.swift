//
//  MyBankNetworkModuleRequestManager.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

protocol MyBankNetworkModuleRequestManagerProtocol {
    func perform<T: Decodable>(_ request: MyBankNetworkModuleRequestProtocol) async throws -> T
}

public class MyBankNetworkModuleRequestManager: MyBankNetworkModuleRequestManagerProtocol {
    let apiManager: MyBankNetworkModuleAPIManagerProtocol
    let parser: MyBankNetworkModuleDataParserProtocol
    
    public init() {
        self.apiManager = MyBankNetworkModuleAPIManager()
        self.parser = MyBankNetworkModuleDataParser()
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

        let data = try await apiManager.requestToken()

        let token: APIToken = try parser.parse(data: data)

        return token.bearerAccessToken
    }
}
