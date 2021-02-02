//
//  PokemonsListViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

protocol PokemonsListViewModel {
    
    var pokemons: [Pokemon] { get }
    func fetchPokemons()
    
}

class PokemonsListViewModelService: PokemonsListViewModel {

    private(set) var pokemons: [Pokemon] = []

    private let pokemonsListFetcher: PokemonsListFetcher

    init(pokemonsListFetcher: PokemonsListFetcher = PokemonsListFetcherService()) {
        self.pokemonsListFetcher = pokemonsListFetcher
    }

    func fetchPokemons() {

        pokemonsListFetcher.fetch(take: 10, skip: 10) { (response) in
            switch response {
            case .success(let pokemonsList):
                break
            case .failure(let error):
                break
            }
        }

    }

}
