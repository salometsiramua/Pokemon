//
//  PokemonsDetailsFetcherMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import Foundation
@testable import Pokemon

class PokemonsDetailsFetcherMock: PokemonsDetailsFetcher {
    
    private var success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    func fetch(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        if success {
            completion(.success(Pokemon(abilities: [], baseExperience: 23, forms: [], gameIndices: [], height: 43, heldItems: [], id: 23, isDefault: true, locationAreaEncounters: "", moves: [], name: "pickachu", order: 23, species: BasicData(name: "sdd", url: "dasd"), sprites: Sprites(), versions: [], stats: [], types: [], weight: 43)))
        } else {
            completion(.failure(NetworkError.invalidStatusCode))
        }
    }
}
