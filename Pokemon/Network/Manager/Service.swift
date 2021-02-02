//
//  Service.swift
//  Pockemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

enum Service {
    case pokemonsList(take: Int, skip: Int)
}

extension Service: Endpoint {
    
    var baseUrl: URL? {
        URL(string: "https://pokeapi.co/api/v2/")
    }
    
    var path: String {
        switch self {
        case .pokemonsList(let take, let skip):
            return "pokemon?limit=\(take)&offset=\(skip)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .pokemonsList:
            return .get
        }
    }
    
}

