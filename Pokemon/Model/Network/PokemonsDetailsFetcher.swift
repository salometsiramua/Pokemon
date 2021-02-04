//
//  PokemonsDetailsFetcher.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import Foundation

protocol PokemonsDetailsFetcher {
    func fetch(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void)
}

struct PokemonsDetailsFetcherService: PokemonsDetailsFetcher {

    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        guard Reachability.isConnectedToNetwork else {
            return completion(.failure(NetworkError.noInternetConnection))
        }
        
        ServiceManager<Pokemon>(session: self.session, Service.custom(url: url), onSuccess: { (response) in
            completion(.success(response))
        }) { (error) in
            completion(.failure(error))
        }
    }
}
