//
//  MyBankNetworkModuleAPIManager.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

protocol MyBankNetworkModuleAPIManagerProtocol {
    func perform(_ request: MyBankNetworkModuleRequestProtocol, authToken: String) async throws -> Data
    func requestToken() async throws -> Data
}

class MyBankNetworkModuleAPIManager: MyBankNetworkModuleAPIManagerProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: MyBankNetworkModuleRequestProtocol, authToken: String = "") async throws -> Data {

        let (data, response) = try await urlSession.data(for: request.createURLRequest(authToken: authToken))

        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299, 400:
                break
            case 401:
                throw MyBankNetworkModuleNetworkError.unauthorized
            case 403:
                throw MyBankNetworkModuleNetworkError.forbidden
            case 500...511:
                throw MyBankNetworkModuleNetworkError.internalServerError
            default:
                throw MyBankNetworkModuleNetworkError.invalidServerResponse
            }
        }
        return data
    }
    
    func requestToken() async throws -> Data {
        try await perform(MyBankNetworkModuleAuthTokenRequest.auth)
    }
}
