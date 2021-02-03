//
//  DataTaskMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//
//

import Foundation
@testable import Pokemon

class DataTaskMock: URLSessionDataTask {
    
    var cancelHandler: (()->())?
    var resumeHandler: (()->())?
    
    override func resume() {
        resumeHandler?()
    }
    
    override func cancel() {
        cancelHandler?()
    }
    
    override init() { }
    
}
