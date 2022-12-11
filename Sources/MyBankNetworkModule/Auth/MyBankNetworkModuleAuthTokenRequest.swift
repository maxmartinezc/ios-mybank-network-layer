//
//  MyBankNetworkModuleAuthTokenRequest.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

enum MyBankNetworkModuleAuthTokenRequest: MyBankNetworkModuleRequestProtocol {
    case accessToken
    case refreshToken(refreshToken: String)
    
    var path: String {
        switch self {
        case .accessToken, .refreshToken:
            return "/mybank/v2/oauth2/token"
        }
    }

    var params: [String: Any] {
        var data: [String: Any] = [
            "client_id": MyBankNetworkModuleAPIConstants.clientId,
            "client_secret": MyBankNetworkModuleAPIConstants.clientSecret
        ]
        switch self {
        case .accessToken:
            data["grant_type"] = MyBankNetworkModuleAPIConstants.accessTokenGrantType
            return data
        case .refreshToken(let token):
            data["grant_type"] = MyBankNetworkModuleAPIConstants.refreshTokenGrantType
            data["refresh_token"] = token
            return data
        }
    }
    
    var addAuthorizationToken: Bool {
        false
    }
    
    var requestType: MyBankNetworkModuleRequestType {
        .POST
    }
}
