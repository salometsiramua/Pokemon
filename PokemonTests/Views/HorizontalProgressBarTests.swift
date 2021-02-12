//
//  HorizontalProgressBarTests.swift
//  PokemonTests
//
//  Created by Salome Tsiramua on 2/12/21.
//

import XCTest
@testable import Pokemon

class HorizontalProgressBarTests: XCTestCase {

    func testHorizontalProgressBarColor() {
        let progressBar = HorizontalProgressBar(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        XCTAssertEqual(progressBar.color, Constants.Colors.light.value)
        progressBar.color = .red
        XCTAssertEqual(progressBar.color, .red)
    }

    func testHorizontalProgressBarProgress() {
        let progressBar = HorizontalProgressBar(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        XCTAssertEqual(progressBar.progress, 0)
        progressBar.progress = 0.2
        XCTAssertEqual(progressBar.progress, 0.2)
    }
    
    func testHorizontalProgressBarDraw() {
        let progressBar = HorizontalProgressBar(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        XCTAssertNil(progressBar.layer.mask)
        progressBar.draw(rect)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        XCTAssertEqual(progressBar.layer.mask?.bounds, layer.bounds)
    }
}
