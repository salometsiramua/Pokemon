//
//  ViewControllerTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 02.02.21.
//

import XCTest
@testable import Pokemon

class ViewControllerTests: XCTestCase {

    private func makeViewController() -> UIViewController {
        let viewController = PokemonsListViewController()
        UIWindow().addSubview(viewController.view)
        return viewController
    }
    
    func testPokemonsListViewController() {
        
        let vc = makeViewController()
        XCTAssertTrue(vc is PokemonsListViewController)
    }
    
    func testViewControllerInit() {
        let vc = makeViewController()
        XCTAssertNotNil(vc.view)
    }
    
    func testPokemonsDetailsViewController() {
        
        let vc = PokemonsDetailsViewController()
        XCTAssertTrue(vc is PokemonsDetailsViewController)
        XCTAssertNotNil(vc.view)
    }

}
