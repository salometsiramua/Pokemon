//
//  PokemonsDetailsViewModelMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/12/21.
//

import Foundation
@testable import Pokemon

class PokemonsDetailsViewModelMock: PokemonsDetailsViewModel {
    
    var url: String?
    
    var pokemon: Pokemon?
    
    var delegate: PokemonsDetailsUpdatedListener?
    
    func fetchDetails() {
        pokemon = Pokemon(abilities: [], baseExperience: 45, forms: [], gameIndices: [], height: 43, heldItems: [], id: 43, isDefault: true, locationAreaEncounters: "fds", moves: [], name: "tedt", order: 2, species: BasicData(name: "sds", url: "sd"), sprites: Sprites(), versions: nil, stats: [Stat(baseStat: 40, effort: 10, stat: BasicData(name: "Name", url: "url.com")), Stat(baseStat: 40, effort: 10, stat: BasicData(name: "Name", url: "url.com")), Stat(baseStat: 40, effort: 10, stat: BasicData(name: "Name", url: "url.com")), Stat(baseStat: 40, effort: 10, stat: BasicData(name: "Name", url: "url.com"))], types: [Type(slot: 23, type: BasicData(name: "nds", url: "re.com"))], weight: 34)
    }
}
