//
//  PokemonsListFetcher.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

protocol PokemonsListFetcher {
    func fetch(url: String?, completion: @escaping (Result<PokemonsListResponse, Error>) -> Void)
}

struct PokemonsListFetcherService: PokemonsListFetcher {

    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(url: String?, completion: @escaping (Result<PokemonsListResponse, Error>) -> Void) {
        guard Reachability.isConnectedToNetwork else {
            return completion(.failure(NetworkError.noInternetConnection))
        }
        
        let service = url == nil ? Service.pokemonsList(take: 20, skip: 0) : Service.custom(url: url!)
        
        ServiceManager<PokemonsListResponse>(session: self.session, service, onSuccess: { (response) in
            completion(.success(response))
        }) { (error) in
            completion(.failure(error))
        }
    }
}
