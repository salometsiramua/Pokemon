//
//  PokemonsListViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import Foundation

protocol PokemonsListViewModel {
    
    var totalCount: Int { get }
    var pokemons: [PokemonCellViewModel] { get }
    var delegate: PokemonsDataSourceUpdatedListener? { get set }
    func fetchPokemons()
}

class PokemonsListViewModelService: PokemonsListViewModel {
    
    var delegate: PokemonsDataSourceUpdatedListener?
    
    var totalCount: Int = 0
    private var downloadedCount: Int = 0
    private var next: String?
    private var previous: String?
    private var isFetching: Bool = false
    
    private(set) var pokemons: [PokemonCellViewModel] = []

    private let pokemonsListFetcher: PokemonsListFetcher

    init(pokemonsListFetcher: PokemonsListFetcher = PokemonsListFetcherService()) {
        self.pokemonsListFetcher = pokemonsListFetcher
    }

    func fetchPokemons() {
    
        guard !isFetching else {
            return
        }
        
        isFetching = true
        pokemonsListFetcher.fetch(url: next) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let pokemonsList):
                self.isFetching = false
                self.totalCount = pokemonsList.count
                self.next = pokemonsList.next
                self.previous = pokemonsList.previous
                let pokemons = pokemonsList.results.map { PokemonCellViewModel(name: $0.name, imageUrl: nil, url: $0.url)}
                self.pokemons.append(contentsOf: pokemons)
                self.delegate?.reloadTable(rows: self.indexPathsToReload(from: pokemonsList.results))
            case .failure(let error):
                self.isFetching = false
                self.delegate?.showError(error: error)
            }
        }
    }
    
    private func indexPathsToReload(from result: [PokemonsBasicData]) -> [IndexPath] {
      let startIndex = pokemons.count - result.count
      let endIndex = startIndex + result.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
