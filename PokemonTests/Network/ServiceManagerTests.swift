//
//  ServiceManagerTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class ServiceManagerTests: XCTestCase {

    func testRagac() {
        let sessionMock = NetworkSessionMock()
        
        sessionMock.mockData.resumeHandler = {
            XCTFail()
        }
        
        let mgr = ServiceManager<[String: Any]>(session: sessionMock, MockEndpoint())
        
        XCTAssertFalse(mgr.isRunning)
    }
}

extension Dictionary: MappableResponse where Key == String, Value == Any {
    
    public init(data: Data) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dictionary = object as? [String: Any] else {
            throw NetworkError.responseParsingToJsonDictionary
        }
        
        self = dictionary
    }
}
