//
//  PokemonsDetailsFetcherSessionMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import Foundation
@testable import Pokemon

struct PokemonsDetailsFetcherSessionMock: NetworkSession {
    
    private let success: Bool
    private let statusCode: Int
    
    init(success: Bool = true, statusCode: Int = 200) {
        self.success = success
        self.statusCode = statusCode
    }
    
    func dataTask(with url: URLRequest, completionHandler: @escaping HTTPRequestSessionCompletion) -> URLSessionDataTask {
        let responseJsonSuccess = """
            { "abilities": [],
            "base_experience": 101,
            "forms": [],
            "game_indices": [],
            "height": 3,
            "held_items": [],
            "id": 132,
            "is_default": true,
            "location_area_encounters": "https://pokeapi.co/api/v2/pokemon/132/encounters",
            "moves": [],
            "name": "ditto",
            "order": 203,
            "species": {
            "name": "ditto",
            "url": "https://pokeapi.co/api/v2/pokemon-species/132/"
            },
            "sprites": {},
            "stats": [],
            "types": [],
            "weight": 40
            }
        """
        
        let responseJsonError = """
            { "abilities": [],
            "base_experience": 101,
            "forms": [],
            "game_indices": [],
            "height": 3,
            "held_items": [],
            "id": 132,
            "is_default": true,
            "location_area_encounters": "https://pokeapi.co/api/v2/pokemon/132/encounters",
            "species": {
            "name": "ditto",
            "url": "https://pokeapi.co/api/v2/pokemon-species/132/"
            },
            "sprites": {},
            "types": [],
            "weight": 40
            }
        """
        
        let responseJson = success ? responseJsonSuccess : responseJsonError
        
        let data = responseJson.data(using: .utf8)
        
        let response = HTTPURLResponse(url: url.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completionHandler(data, response, nil)
        }
        
        return DataTaskMock()
    }
}
