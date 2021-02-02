//
//  PokemonsListFetcher.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

protocol PokemonsListFetcher {
    func fetch(take: Int, skip: Int, completion: @escaping (Result<PokemonsListResponse, Error>) -> Void)
}

struct PokemonsListFetcherService: PokemonsListFetcher {

    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(take: Int, skip: Int, completion: @escaping (Result<PokemonsListResponse, Error>) -> Void) {
        guard Reachability.isConnectedToNetwork else {
            return completion(.failure(NetworkError.noInternetConnection))
        }
        
        ServiceManager<PokemonsListResponse>(session: self.session, Service.pokemonsList(take: take, skip: skip), onSuccess: { (response) in
            completion(.success(response))
        }) { (error) in
            completion(.failure(error))
        }
    }
}
