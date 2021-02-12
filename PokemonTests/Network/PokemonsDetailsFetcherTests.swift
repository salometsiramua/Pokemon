//
//  PokemonsDetailsFetcherTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import XCTest
@testable import Pokemon

class PokemonsDetailsFetcherTests: XCTestCase {

    func testPokemonsDetailsFetcherCall() {
        let fetcher = PokemonsDetailsFetcherService(session: PokemonsDetailsFetcherSessionMock(success: true))
        
        let exp = expectation(description: "Pokemons details fetcher succeed")
        fetcher.fetch(url: "www.poke.api") { (result) in
            exp.fulfill()
            XCTAssertNotNil(result)
            switch result {
            case .success(let pokemon):
                XCTAssertEqual(pokemon.name, "ditto")
                XCTAssertEqual(pokemon.weight, 40)
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [exp], timeout: 0.4)
    }
    
    func testPokemonsDetailsFetcherCallFailingCase() {
        let fetcher = PokemonsDetailsFetcherService(session: PokemonsDetailsFetcherSessionMock(success: false))
        
        let exp = expectation(description: "Pokemons details fetcher succeed")
        fetcher.fetch(url: "www.poke.api") { (result) in
            exp.fulfill()
            XCTAssertNotNil(result)
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
            }
        }
        
        wait(for: [exp], timeout: 0.4)
    }
    
    func testPokemonsDetailsFetcherStatusCodeError() {
        let fetcher = PokemonsDetailsFetcherService(session: PokemonsDetailsFetcherSessionMock(success: true, statusCode: 400))
        
        let exp = expectation(description: "Pokemons details fetcher succeed")
        fetcher.fetch(url: "www.poke.api") { (result) in
            exp.fulfill()
            XCTAssertNotNil(result)
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (Pokemon.NetworkError error 0.)")
            }
        }
        
        wait(for: [exp], timeout: 0.4)
    }

}
