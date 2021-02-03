//
//  ServiceTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class ServiceTests: XCTestCase {
    
    func testPokemonsListPath() {
        let pokemonsList = Service.pokemonsList(take: 3, skip: 5)
        XCTAssertEqual(pokemonsList.path, "pokemon?offset=5&limit=3")
    }
    
    func testCustomUrlPath() {
        let customUrl = Service.custom(url: "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200")
        XCTAssertEqual(customUrl.path, "")
    }
    
    func testPokemonsListHTTPMethod() {
        let pokemonsList = Service.pokemonsList(take: 3, skip: 5)
        XCTAssertEqual(pokemonsList.httpMethod, .get)
    }
    
    func testCustomUrlHTTPMethod() {
        let customUrl = Service.custom(url: "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200")
        XCTAssertEqual(customUrl.httpMethod, .get)
    }

    func testPokemonsListBaseUrl() {
        let pokemonsList = Service.pokemonsList(take: 3, skip: 5)
        XCTAssertEqual(pokemonsList.baseUrl?.absoluteString, "https://pokeapi.co/api/v2/")
    }
    
    func testCustomUrlBaseUrl() {
        let customUrl = Service.custom(url: "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200")
        XCTAssertEqual(customUrl.baseUrl?.absoluteString, "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200")
    }
}
