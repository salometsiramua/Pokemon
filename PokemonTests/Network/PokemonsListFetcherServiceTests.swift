//
//  PokemonsListFetcherServiceTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

struct PokemonsListFetcherSessionMock: NetworkSession {
    
    func dataTask(with url: URLRequest, completionHandler: @escaping HTTPRequestSessionCompletion) -> URLSessionDataTask {
        let responseJson = """
            {"count":1118,"next":"https://pokeapi.co/api/v2/pokemon?offset=300&limit=100","previous":"https://pokeapi.co/api/v2/pokemon?offset=100&limit=100","results":[{"name":"unown","url":"https://pokeapi.co/api/v2/pokemon/201/"},{"name":"wobbuffet","url":"https://pokeapi.co/api/v2/pokemon/202/"},{"name":"girafarig","url":"https://pokeapi.co/api/v2/pokemon/203/"},{"name":"pineco","url":"https://pokeapi.co/api/v2/pokemon/204/"},{"name":"forretress","url":"https://pokeapi.co/api/v2/pokemon/205/"},{"name":"dunsparce","url":"https://pokeapi.co/api/v2/pokemon/206/"},{"name":"gligar","url":"https://pokeapi.co/api/v2/pokemon/207/"},{"name":"steelix","url":"https://pokeapi.co/api/v2/pokemon/208/"},{"name":"snubbull","url":"https://pokeapi.co/api/v2/pokemon/209/"},{"name":"granbull","url":"https://pokeapi.co/api/v2/pokemon/210/"},{"name":"qwilfish","url":"https://pokeapi.co/api/v2/pokemon/211/"},{"name":"scizor","url":"https://pokeapi.co/api/v2/pokemon/212/"}]}
        """
        
        let data = responseJson.data(using: .utf8)
        
        let response = HTTPURLResponse(url: url.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completionHandler(data, response, nil)
        }
        
        return DataTaskMock()
    }
}

class PokemonsListFetcherServiceTests: XCTestCase {

    func testPokemonsListFetcherServiceTests() {
        
        let service = `PokemonsListFetcherService`(session: PokemonsListFetcherSessionMock())
        
        let exp = expectation(description: "Pokemons list fetcher succeed")
        
        service.fetch(take: 20, skip: 20){ (result) in
            exp.fulfill()
            XCTAssertNotNil(result)
        }
        
        wait(for: [exp], timeout: 0.4)
        
    }

}
