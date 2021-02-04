//
//  Endpoint.swift
//  Pockemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

protocol Endpoint {
    var baseUrl: URL? { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}
