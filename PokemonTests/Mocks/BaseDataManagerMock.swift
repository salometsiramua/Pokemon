//
//  BaseDataManagerMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import Foundation
@testable import Pokemon

class BaseDataManagerMock: DataBaseManager {
    private(set) var pokemons: [PokemonCellViewModel] = []
    
    func save(results: [PokemonCellViewModel]) {
        pokemons.append(contentsOf: results)
    }
    
    func fetchPokemonsList() -> [PokemonsListObject]? {
        return pokemons.map {
            let object = PokemonsListObject()
            object.name = $0.name
            object.url = $0.url
            object.image = $0.image.image?.pngData()
            return object
        }
    }
    
    func saveImage(for pokemonCellViewModel: PokemonCellViewModel) {
        var pokemon = pokemons.first { (model) -> Bool in
            model == pokemonCellViewModel
        }
        pokemon?.image = pokemonCellViewModel.image
    }
}
