//
//  PokemonsDetailsViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import Foundation

protocol PokemonsDetailsViewModel {
    var url: String? { get }
    var pokemon: Pokemon? { get }
    var delegate: PokemonsDetailsUpdatedListener? { get set }
    func fetchDetails()
}

class PokemonsDetailsViewModelService: PokemonsDetailsViewModel {
    
    var delegate: PokemonsDetailsUpdatedListener?
    var url: String?

    private let pokemonsDetailsFetcher: PokemonsDetailsFetcher

    var pokemon: Pokemon?
    
    init(pokemonsDetailsFetcher: PokemonsDetailsFetcher = PokemonsDetailsFetcherService(), url: String?) {
        self.pokemonsDetailsFetcher = pokemonsDetailsFetcher
        self.url = url
    }

    func fetchDetails() {
        guard let url = url else { return }
        
        pokemonsDetailsFetcher.fetch(url: url) { [weak self] (result) in
            switch result {
            case .success(let pokemon):
                self?.pokemon = pokemon
                self?.delegate?.reload()
            case .failure(let error):
                self?.delegate?.showError(error: error)
            }
        }
    }
}
