//
//  PokemonsListViewControllerTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/12/21.
//

import XCTest
@testable import Pokemon

class PokemonsListViewControllerTests: XCTestCase {

    private func makeViewController() -> PokemonsListViewController {
        let viewController = PokemonsListViewController(viewModel: PokemonsListViewModelMock())
        UIWindow().addSubview(viewController.view)
        return viewController
    }
    
    func testViewControllerInit() {
        let vc = makeViewController()
        XCTAssertNotNil(vc.view)
    }
}
