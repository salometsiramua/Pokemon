//
//  UILabel+Extensions.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/4/21.
//

import UIKit

extension UILabel {
    func setStyle(_ style: Constants.Style) {
        font = style.font
        textColor = style.color
    }
}
