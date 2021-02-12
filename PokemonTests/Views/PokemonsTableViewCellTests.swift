//
//  PokemonsTableViewCellTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/12/21.
//

import XCTest
@testable import Pokemon

class PokemonsTableViewCellTests: XCTestCase {

    func testComparePokemonsCellModels() {
        let model1 = PokemonCellViewModel(name: "Salome", url: "url.com", image: Image(url: nil))
        let model2 = PokemonCellViewModel(name: "Giorgi", url: "url.com", image: Image(url: nil))
        XCTAssertNotNil(model1)
        XCTAssertNotNil(model2)
        XCTAssertEqual(model1, model2)
    }
    
    func testPokemonsCellViewModelInitWithEmptyName() {
        let model = PokemonCellViewModel(name: nil, url: "", image: Image(url: nil))
        XCTAssertNil(model)
    }

    func testPokemonsCellViewModelInit() {
        let model = PokemonCellViewModel(name: "Boo", url: "url.com", image: Image(url: "image.com"))
        XCTAssertEqual(model?.name, "Boo")
        XCTAssertEqual(model?.url, "url.com")
    }
    
    func testPokemonsCell() {
        let cell = PokemonTableViewCell(style: .value1, reuseIdentifier: "PokemonTableViewCell")
        XCTAssertEqual(cell.avatar.contentMode, .scaleAspectFit)
    }
}
