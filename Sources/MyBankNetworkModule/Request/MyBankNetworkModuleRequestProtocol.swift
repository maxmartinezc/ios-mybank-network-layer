//
//  MyBankNetworkModuleRequestProtocol.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//
import Foundation

public protocol MyBankNetworkModuleRequestProtocol {
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var addAuthorizationToken: Bool { get }
    var requestType: MyBankNetworkModuleRequestType { get }
}

public extension MyBankNetworkModuleRequestProtocol {
    var schema: String {
        MyBankNetworkModuleAPIConstants.schema
    }
    
    var port: Int {
        MyBankNetworkModuleAPIConstants.port
    }
    
    var host: String {
        MyBankNetworkModuleAPIConstants.host
    }
    
    var addAuthorizationToken: Bool {
        true
    }
    
    var params: [String: Any] {
        [:]
    }

    var urlParams: [String: String?] {
        [:]
    }
    
    var headers: [String: String] {
        [:]
    }
    
    func createURLRequest(authToken: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = schema
        components.host = host
        components.port = port
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else { throw MyBankNetworkModuleNetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        if addAuthorizationToken {
            urlRequest.setValue(authToken, forHTTPHeaderField: MyBankNetworkModuleAPIConstants.authorizationHeader)
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: params)
        }
        return urlRequest
    }
}
