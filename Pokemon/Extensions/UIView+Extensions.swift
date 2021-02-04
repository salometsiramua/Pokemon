//
//  UIView+Extensions.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/4/21.
//

import UIKit

enum Direction {
    case top
    case bottom
    case leading
    case trailing
    case centerX
    case centerY
}

extension UIView {
    class var identifier: String {
        return String(describing: self)
    }
    
    func pin(to view: UIView, directions: [Direction] = [.top, .bottom, .leading, .trailing], edgeInsets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        directions.forEach { (direction) in
            switch direction {
            case .top:
                topAnchor.constraint(equalTo: view.topAnchor, constant: edgeInsets.top).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -edgeInsets.bottom).isActive = true
            case .leading:
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInsets.left).isActive = true
                guard !directions.contains(.trailing) else {
                    return
                }
                trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -edgeInsets.right).isActive = true
            case .trailing:
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeInsets.right).isActive = true
            case .centerX:
                centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            case .centerY:
                centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            }
        }
    }
}
