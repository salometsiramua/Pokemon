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
        
        var value: UIColor {
            switch self {
            case .background:
                return UIColor(named: "background") ?? .white
            case .title:
                return UIColor(named: "title") ?? .black
            }
        }
    }
    
    enum Spacing {
        case margin
        
        var value: CGFloat {
            switch self {
            case .margin:
                return 30                
            }
        }
    }
}


