//
//  PokemonsListViewModelMock.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import Foundation
@testable import Pokemon

class PokemonsListViewModelMock: PokemonsListViewModel {
    
    var totalCount: Int = 2323
    
    var pokemons: [Int : PokemonCellViewModel] = [:]
    
    var delegate: PokemonsDataSourceUpdatedListener?
    
    var isDownloading: Bool = false
    
    func fetchPokemons(for indexes: [Int]) {
        for i in 0...20 {
            pokemons[i] = PokemonCellViewModel(name: "Pokemon\(i)", url: "https://pokeapi.co/api/v2/pokemon/\(i)/", image: Image(url: "https://pokeapi.co/api/v2/pokemon/\(i)/", image: nil))
        }
        let indexPathes = indexes.map { IndexPath(row: $0, section: 0)}
        delegate?.reloadTable(rows: indexPathes)
    }
    
    func suspendAllOperations() {
        isDownloading = false
    }
    
    func resumeAllOperations() {
        isDownloading = true
    }
    
    func image(for cell: IndexPath) {
        
    }
    
    func images(for cells: [IndexPath]?) {
        
    }
}
