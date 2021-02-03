//
//  MockEndpoint.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation
@testable import Pokemon

struct MockEndpoint: Endpoint {
    
    var baseUrl: URL?
    
    var path: String
    
    var httpMethod: HTTPMethod
    
    init(baseUrl: URL = URL(string: "github.com/tests/")!, path: String = "/testMock", httpMethod: HTTPMethod = .get) {
        self.baseUrl = baseUrl
        self.path = path
        self.httpMethod = httpMethod
    }

}
