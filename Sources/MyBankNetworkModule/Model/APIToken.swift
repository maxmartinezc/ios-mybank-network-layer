//
//  APIToken.swift
//
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

struct APIToken {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
    let refreshToken: String
    private let requestedAt = Date()
}

// MARK: - Codable
extension APIToken: Codable {
    enum CodingKeys: String, CodingKey {
        case tokenType
        case expiresIn
        case accessToken
        case refreshToken
    }
}

// MARK: - Helper properties
extension APIToken {
    var expiresAt: Date {
        Calendar.current.date(byAdding: .second, value: expiresIn, to: requestedAt) ?? Date()
    }
    
    var bearerAccessToken: String {
        "\(tokenType) \(accessToken)"
    }
}
