//
//  Constants.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

enum Constants {
    enum Colors {
        case background
        case title
        case light
        case appColor
        case clear
        
        var value: UIColor {
            switch self {
            case .background:
                return UIColor(named: "background") ?? .white
            case .light:
                return .lightGray
            case .title:
                return UIColor(named: "title") ?? .black
            case .appColor:
                return .green
            case .clear:
                return .clear
            }
        }
    }
    
    enum Spacing {
        case margin
        case padding
        case topMargin
        
        var value: CGFloat {
            switch self {
            case .margin:
                return 30
            case .padding:
                return 10
            case .topMargin:
                return 50
            }
        }
    }
    
    enum Style {
        case header
        case title
        case text
        
        var font: UIFont {
            switch self {
            case .header:
                return .systemFont(ofSize: 20)
            case .title:
                return .systemFont(ofSize: 25)
            case .text:
                return .systemFont(ofSize: 18)
            }
        }
        
        var color: UIColor {
            return Colors.title.value
        }
    }
}


