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

class PokemonsListFetcherService: PokemonsListFetcher {

    private let session: NetworkSession
    @Atomic private var blocks: [(Int, DispatchWorkItem)] = []
    private let maximumBlocksCount = 5

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(take: Int, skip: Int, completion: @escaping (Result<PokemonsListResponse, Error>) -> Void) {
        guard Reachability.isConnectedToNetwork else {
            return completion(.failure(NetworkError.noInternetConnection))
        }
    
        blocks.removeAll { (item) -> Bool in
            item.1.isCancelled
        }

        let contains = blocks.contains { (item) -> Bool in
            item.0 == skip
        }

        guard !contains else {
            return
        }
        
        if blocks.count >= maximumBlocksCount {
            blocks.first?.1.cancel()
        }
        
        let block = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            ServiceManager<PokemonsListResponse>(session: self.session, Service.pokemonsList(take: take, skip: skip), onSuccess: { (response) in
                completion(.success(response))
            }) { (error) in
                completion(.failure(error))
            }
        }
        
        blocks.append((skip, block))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                              execute: block)
    }
}
