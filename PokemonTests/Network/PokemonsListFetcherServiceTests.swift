//
//  PokemonsListFetcherServiceTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class PokemonsListFetcherServiceTests: XCTestCase {

    func testPokemonsListFetcherServiceTests() {
        
        let service = `PokemonsListFetcherService`(session: PokemonsListFetcherSessionMock())
        
        let exp = expectation(description: "Pokemons list fetcher succeed")
        
        service.fetch(take: 20, skip: 20){ (result) in
            exp.fulfill()
            XCTAssertNotNil(result)
        }
        
        wait(for: [exp], timeout: 1)
        
    }

}
