//
//  UIView+Tests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class UIViewTests: XCTestCase {

    func testViewIdentifier() {
        XCTAssertEqual(PokemonTableViewCell.identifier, "PokemonTableViewCell")
        XCTAssertEqual(UIView.identifier, "UIView")
    }
}
