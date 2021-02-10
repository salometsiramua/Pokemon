//
//  PokemonCellViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import Foundation

struct PokemonCellViewModel {
    let name: String
    let url: String
    var image: Image
    
    init?(name: String?, url: String, image: Image) {
        guard let name = name else {
            return nil
        }
        self.name = name
        self.url = url
        self.image = image
    }
}
