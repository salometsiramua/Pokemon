//
//  NetworkSessionMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation
@testable import Pokemon

struct NetworkSessionMock: NetworkSession {
    
    let success: Bool
    
    init(success: Bool = true) {
        self.success = success
    }
    
    var mockData: DataTaskMock = DataTaskMock()
    
    func dataTask(with url: URLRequest, completionHandler: @escaping HTTPRequestSessionCompletion) -> URLSessionDataTask {
        
        if !success {
            completionHandler(nil, mockData.response, NetworkError.responseDataIsNil)
        }
        
        return mockData
    }
    
}
