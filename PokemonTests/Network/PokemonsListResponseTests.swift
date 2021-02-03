//
//  RespositoriesResponseTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class PokemonsListResponseTests: XCTestCase {

    func testPokemonsListResponse() {
        do {
            let responseJson = """
            
            {"count":1118,"next":"https://pokeapi.co/api/v2/pokemon?offset=300&limit=100","previous":"https://pokeapi.co/api/v2/pokemon?offset=100&limit=100","results":[{"name":"unown","url":"https://pokeapi.co/api/v2/pokemon/201/"},{"name":"wobbuffet","url":"https://pokeapi.co/api/v2/pokemon/202/"},{"name":"girafarig","url":"https://pokeapi.co/api/v2/pokemon/203/"},{"name":"pineco","url":"https://pokeapi.co/api/v2/pokemon/204/"},{"name":"forretress","url":"https://pokeapi.co/api/v2/pokemon/205/"},{"name":"dunsparce","url":"https://pokeapi.co/api/v2/pokemon/206/"},{"name":"gligar","url":"https://pokeapi.co/api/v2/pokemon/207/"},{"name":"steelix","url":"https://pokeapi.co/api/v2/pokemon/208/"},{"name":"snubbull","url":"https://pokeapi.co/api/v2/pokemon/209/"},{"name":"granbull","url":"https://pokeapi.co/api/v2/pokemon/210/"},{"name":"qwilfish","url":"https://pokeapi.co/api/v2/pokemon/211/"},{"name":"scizor","url":"https://pokeapi.co/api/v2/pokemon/212/"}]}
            
            """
            
            guard let data = responseJson.data(using: .utf8) else {
                XCTFail()
                return
            }
            
            let pokemonsListResponse = try PokemonsListResponse(data: data)
            XCTAssertNotNil(pokemonsListResponse)
            XCTAssertEqual(pokemonsListResponse.results.count, 12)
            XCTAssertEqual(pokemonsListResponse.count, 1118)
            XCTAssertEqual(pokemonsListResponse.previous, "https://pokeapi.co/api/v2/pokemon?offset=100&limit=100")
            XCTAssertNotNil(pokemonsListResponse.next)
            
        } catch {
            XCTFail()
        }
    }

    func testPokemonsListResponseCountMissing() {
        do {
            let responseJson = """
                        {"next":"https://pokeapi.co/api/v2/pokemon?offset=300&limit=100","previous":"https://pokeapi.co/api/v2/pokemon?offset=100&limit=100","results":[{"name":"unown","url":"https://pokeapi.co/api/v2/pokemon/201/"},{"name":"wobbuffet","url":"https://pokeapi.co/api/v2/pokemon/202/"},{"name":"girafarig","url":"https://pokeapi.co/api/v2/pokemon/203/"},{"name":"pineco","url":"https://pokeapi.co/api/v2/pokemon/204/"},{"name":"forretress","url":"https://pokeapi.co/api/v2/pokemon/205/"},{"name":"dunsparce","url":"https://pokeapi.co/api/v2/pokemon/206/"},{"name":"gligar","url":"https://pokeapi.co/api/v2/pokemon/207/"},{"name":"steelix","url":"https://pokeapi.co/api/v2/pokemon/208/"},{"name":"snubbull","url":"https://pokeapi.co/api/v2/pokemon/209/"},{"name":"granbull","url":"https://pokeapi.co/api/v2/pokemon/210/"},{"name":"qwilfish","url":"https://pokeapi.co/api/v2/pokemon/211/"},{"name":"scizor","url":"https://pokeapi.co/api/v2/pokemon/212/"}]}
            """
            
            guard let data = responseJson.data(using: .utf8) else {
                XCTFail()
                return
            }
            
            _ = try PokemonsListResponse(data: data)
            XCTFail("Shouldn't create object without count")
        } catch {
            
        }
    }
    
    func testPokemonsListResponseResultsArrayMissing() {
        do {
            let responseJson = """
                        {"count":1118, "next":"https://pokeapi.co/api/v2/pokemon?offset=300&limit=100","previous":"https://pokeapi.co/api/v2/pokemon?offset=100&limit=100"}
            """
            
            guard let data = responseJson.data(using: .utf8) else {
                XCTFail()
                return
            }
            
            _ = try PokemonsListResponse(data: data)
            XCTFail("Shouldn't create object without results array")
        } catch {
            
        }
    }
}
