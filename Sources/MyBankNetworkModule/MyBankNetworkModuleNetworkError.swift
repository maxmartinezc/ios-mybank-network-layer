//
//  MyBankNetworkModuleNetworkError.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

enum MyBankNetworkModuleNetworkError: LocalizedError {
    case invalidServerResponse
    case invalidURL
    case unauthorized
    case forbidden
    case internalServerError

    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        case .unauthorized:
            return "401 - Unauthorized"
        case .forbidden:
            return "403 - Forbidden"
        case .internalServerError:
            return "500 - Internal Server Error"
        }
    }
}
