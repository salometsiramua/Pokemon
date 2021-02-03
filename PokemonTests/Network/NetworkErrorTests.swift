//
//  NetworkErrorTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class NetworkErrorTests: XCTestCase {

    func testNetworkErrorDescriptions() {
        XCTAssertEqual(NetworkError.invalidStatusCode.description, "Status code is invalid")
        XCTAssertEqual(NetworkError.responseDataIsNil.description, "URL response data is nil")
        XCTAssertEqual(NetworkError.responseIsNil.description, "URL response is nil")
        XCTAssertEqual(NetworkError.responseParsingToJsonDictionary.description, "Could not parse to json dictionary")
        XCTAssertEqual(NetworkError.responseError(statusCode: 400, response: nil).description, "[400] - Response Error, undefined")
    }

}


