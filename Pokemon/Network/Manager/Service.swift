//
//  Service.swift
//  Pockemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

enum Service {
    case pokemonsList(take: Int, skip: Int)
    case custom(url: String)
}

extension Service: Endpoint {
    
    var baseUrl: URL? {
        switch self {
        case .custom(let url):
            return URL(string: url)
        default:
            return URL(string: "https://pokeapi.co/api/v2/")
        }
    }
    
    var path: String {
        switch self {
        case .pokemonsList(let take, let skip):
            return "pokemon?offset=\(skip)&limit=\(take)"
        case .custom:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .pokemonsList, .custom:
            return .get
        }
    }
    
}

