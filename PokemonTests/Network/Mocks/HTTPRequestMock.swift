//
//  HTTPRequestMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation
@testable import Pokemon

struct HTTPRequestMock: HTTPRequest {
    
    var urlRequest: URLRequest {
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }
    
    private var urlString: String
    
    init(urlString: String = "localhost.com/tests") {
        self.urlString = urlString
    }
    
}

