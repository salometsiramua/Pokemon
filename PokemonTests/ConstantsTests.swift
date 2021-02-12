//
//  ConstantsTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/11/21.
//

import XCTest
@testable import Pokemon

class ConstantsTests: XCTestCase {
    
    func testBackgroundColor() {
        let background = Constants.Colors.background
        XCTAssertEqual(background.value, UIColor(named: "background"))
    }
    
    func testTitleColor() {
        let title = Constants.Colors.title
        XCTAssertEqual(title.value, UIColor(named: "title"))
    }
    
    func testClearColor() {
        let clear = Constants.Colors.clear
        XCTAssertEqual(clear.value, .clear)
    }
    
    func testAppColor() {
        let appColor = Constants.Colors.appColor
        XCTAssertEqual(appColor.value, .green)
    }
    
    func testLightColor() {
        let lightColor = Constants.Colors.light
        XCTAssertEqual(lightColor.value, .lightGray)
    }
    
    func testSpacing() {
        XCTAssertEqual(Constants.Spacing.margin.value, 30)
        XCTAssertEqual(Constants.Spacing.padding.value, 10)
        XCTAssertEqual(Constants.Spacing.topMargin.value, 50)
    }
    
    func testStyle() {
        XCTAssertEqual(Constants.Style.header.font, .systemFont(ofSize: 20))
        XCTAssertEqual(Constants.Style.title.font, .systemFont(ofSize: 25))
        XCTAssertEqual(Constants.Style.text.font, .systemFont(ofSize: 18))
        XCTAssertEqual(Constants.Style.text.color, Constants.Colors.title.value)
        
    }
}
