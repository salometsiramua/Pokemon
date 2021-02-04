//
//  StringTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2.2.21.
//

import XCTest
@testable import Pokemon

class StringTests: XCTestCase {
 
    func testGetPokemonsIndexFromUrl() {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/201/"
        XCTAssertEqual(url.pokemonsIndex, "201")
    }
    
    func testGetPokemonsIndexFromUrlFailing() {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/343/master/sprites/pokemon/other/official-artwork.201.png"
        XCTAssertNotEqual(url.pokemonsIndex, "201")
    }
    
    func testGetPokemonsIndexFromUrlBigNumber() {
        let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/299/"
        XCTAssertEqual(url.pokemonsIndex, "299")
    }
}
