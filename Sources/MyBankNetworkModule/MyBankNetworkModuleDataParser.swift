//
//  MyBankNetworkModuleDataParser.swift
//  
//
//  Created by Max Martinez Cartagena on 18-11-22.
//

import Foundation

protocol MyBankNetworkModuleDataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

class MyBankNetworkModuleDataParser: MyBankNetworkModuleDataParserProtocol {
    private var jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func parse<T: Decodable>(data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
