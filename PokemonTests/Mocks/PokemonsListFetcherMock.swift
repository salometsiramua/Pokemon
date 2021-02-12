//
//  PokemonsListFetcherMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import Foundation
@testable import Pokemon

class PokemonsListFetcherMock: PokemonsListFetcher {
    
    private var success = true
    
    init(success: Bool = true) {
        self.success = success
    }
    
    func fetch(take: Int, skip: Int, completion: @escaping (Result<PokemonsListResponse, Error>) -> Void) {
        guard success else {
            completion(.failure(NetworkError.responseDataIsNil))
            return
        }
        
        completion(.success(PokemonsListResponse(count: 341, next: "https://pokeapi.co/api/v2/pokemon?offset=300&limit=100", previous: "https://pokeapi.co/api/v2/pokemon?offset=100&limit=100", results: [PokemonsBasicData(name: "slugma", url: "https://pokeapi.co/api/v2/pokemon/218/"), PokemonsBasicData(name: "magcargo", url: "https://pokeapi.co/api/v2/pokemon/219/")])))
    }
}
