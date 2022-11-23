//
//  AuthTokenRequest.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

// 1
enum MyBankNetworkModuleAuthTokenRequest: MyBankNetworkModuleRequestProtocol {
    case auth
    
    var path: String {
        "/mybank/v2/oauth2/token"
    }

    var params: [String: Any] {
        [
            "grant_type": MyBankNetworkModuleAPIConstants.grantType,
            "client_id": MyBankNetworkModuleAPIConstants.clientId,
            "client_secret": MyBankNetworkModuleAPIConstants.clientSecret
        ]
    }

    var addAuthorizationToken: Bool {
        false
    }

    var requestType: MyBankNetworkModuleRequestType {
        .POST
    }
}
