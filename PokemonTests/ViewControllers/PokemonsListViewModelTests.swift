//
//  PokemonsListViewModelTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import XCTest
@testable import Pokemon

class PokemonsListViewModelTests: XCTestCase {
    
    func testPokemonsListViewModelFetchPokemons() {
        
        let model: PokemonsListViewModel = PokemonsListViewModelService(pokemonsListFetcher: PokemonsListFetcherMock(success: true), dataBaseManager: BaseDataManagerMock())
        XCTAssertTrue(model.pokemons.isEmpty)
        model.fetchPokemons(for: [3])
        XCTAssertFalse(model.pokemons.isEmpty)
        XCTAssertEqual(model.pokemons.count, 2)
    }
    
    func testPokemonsListViewModelImages() {
        let model: PokemonsListViewModel = PokemonsListViewModelService(pokemonsListFetcher: PokemonsListFetcherMock(success: true), dataBaseManager: BaseDataManagerMock())
        model.image(for: IndexPath(row: 4, section: 0))
        
    }
}
