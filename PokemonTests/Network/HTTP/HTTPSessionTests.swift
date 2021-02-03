//
//  HTTPSessionTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class HTTPSessionTests: XCTestCase {

    func testSessionResumeTaskOnRequest() {
        let exp = expectation(description: "Resume task called")
        
        let networkSession = NetworkSessionMock()
        
        networkSession.mockData.resumeHandler = {
            exp.fulfill()
        }
        
        let session = HTTPSession(session: networkSession)
        session.request(HTTPRequestMock()) { (_, _, _) in
            XCTFail()
        }
        
        waitForExpectations(timeout: 0.5) { (error) in
            if let error = error {
                XCTFail("Error: \(error)")
            }
        }
    }

}
