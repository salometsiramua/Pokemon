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
        let model: PokemonsDetailsViewModel = PokemonsDetailsViewModelService(pokemonsDetailsFetcher: PokemonsDetailsFetcherMock(success: true), url: "https://pokeapi.co/api/v2/pokemon/212/")
        
        model.fetchDetails()
        
        let exp = expectation(description: "Fetching pokemon")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(model.pokemon)
            XCTAssertEqual(model.pokemon?.weight, 43)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testPokemonsDetailsViewModelReturningFailure() {
        let model: PokemonsDetailsViewModel = PokemonsDetailsViewModelService(pokemonsDetailsFetcher: PokemonsDetailsFetcherMock(success: false), url: nil)
        
        model.fetchDetails()
        
        let exp = expectation(description: "Fetching pokemon")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(model.pokemon)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
}



