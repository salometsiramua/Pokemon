//
//  HTTPMethodTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class HTTPMethodTests: XCTestCase {

    func testRawValues() {
      
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")        
    }

}
