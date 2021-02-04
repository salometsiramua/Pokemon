//
//  PokemonsDetailsViewModelTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua 2/4/21.
//

import XCTest
@testable import Pokemon

class PokemonsDetailsViewModelTests: XCTestCase {
    
    func testPokemonsDetailsViewModel() {
        let model: PokemonsDetailsViewModel = PokemonsDetailsViewModelService(pokemonsDetailsFetcher: PokemonsDetailsFetcherMock(success: true), url: nil)
        
        model.fetchDetails()
        
    }
    
    func testPokemonsDetailsViewModelReturningFailure() {
        
    }
}

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

