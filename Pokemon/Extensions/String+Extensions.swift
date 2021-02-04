//
//  String+Extensions.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

extension String {
    var pokemonsIndex: String? {
        guard let index = split(separator: "/").last else {
            return nil
        }
        return String(index)
    }
}
