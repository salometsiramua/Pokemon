//
//  PokemonsDetailsViewControllerTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/12/21.
//

import XCTest
@testable import Pokemon

class PokemonsDetailsViewControllerTests: XCTestCase {

    func testPokemonsDetailsViewController() {
        
        let vc = PokemonsDetailsViewController(viewModel: PokemonsDetailsViewModelService(url: nil))
        XCTAssertNotNil(vc.view)
    }
    
    func testPokemonsDetailsViewControllerScrollView() {
        let vc = PokemonsDetailsViewController(viewModel: PokemonsDetailsViewModelMock())
        let scrollView = UIScrollView()
        scrollView.setContentOffset(.init(x: 100, y: 100), animated: false)
        XCTAssertEqual(scrollView.contentOffset.y, 100)
        scrollView.tag = DetailsScreenScrollViews.images.rawValue
        vc.scrollViewDidScroll(scrollView)
        XCTAssertEqual(scrollView.contentOffset.y, 0)
    }
    
    func testPokemonsDetailsViewControllerReload() {
        let vc = PokemonsDetailsViewController(viewModel: PokemonsDetailsViewModelMock())
        UIWindow().addSubview(vc.view)
        vc.startIndicatingActivity()
        vc.reload()
        XCTAssertFalse(vc.indicator.isAnimating)
    }
    
    func testPokemonsDetailsViewControllerFetching() {
        let vc = PokemonsDetailsViewController(viewModel: PokemonsDetailsViewModelMock())
        XCTAssertNil(vc.viewModel.pokemon)
        vc.viewModel.fetchDetails()
        XCTAssertNotNil(vc.viewModel.pokemon)
    }
}
