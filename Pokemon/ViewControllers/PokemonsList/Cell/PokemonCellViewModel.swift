//
//  PokemonCellViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

struct PokemonCellViewModel {
    var name: String
    var url: String
    var image: UIImage?
    
    init?(name: String?, url: String?, image: UIImage?) {
        guard let name = name, let url = url else {
            return nil
        }
        self.name = name
        self.url = url
        self.image = image
    }
}
