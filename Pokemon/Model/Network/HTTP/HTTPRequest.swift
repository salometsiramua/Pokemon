//
//  HTTPRequest.swift
//  Pockemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

protocol HTTPRequest {
    var urlRequest: URLRequest { get }
}

protocol NetworkSession {
    func dataTask(with url: URLRequest, completionHandler: @escaping HTTPRequestSessionCompletion) -> URLSessionDataTask
}

extension URLSession: NetworkSession { }

class HTTPSession: HTTPRequestSession {
    
    private var dataTask: URLSessionDataTask?
    private var session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: HTTPRequest, completion: @escaping HTTPRequestSessionCompletion) {
        dataTask = session.dataTask(with: request.urlRequest, completionHandler: { data, response, error in
            completion(data, response, error)
        })
        dataTask?.resume()
    }
    
    func cancel() {
        dataTask?.cancel()
    }

}
