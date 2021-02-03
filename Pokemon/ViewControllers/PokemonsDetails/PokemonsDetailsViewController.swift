//
//  PokemonsDetailsViewController.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

protocol PokemonsDetailsUpdatedListener {
    func reload()
    func showError(error: Error)
}


class PokemonsDetailsViewController: UIViewController {

    var viewModel: PokemonsDetailsViewModel?
    
    private var name = UILabel(frame: .zero)
    private var weight = UILabel(frame: .zero)
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Constants.Colors.background.value
        
        view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.margin.value).isActive = true
        
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Spacing.margin.value).isActive = true
        
        name.textColor = Constants.Colors.title.value
        
        viewModel?.delegate = self
        viewModel?.fetchDetails()
        
    }
}

extension PokemonsDetailsViewController: PokemonsDetailsUpdatedListener {
    
    func reload() {
        DispatchQueue.main.async {
            self.name.text = self.viewModel?.pokemon?.name
        }
    }
    
    func showError(error: Error) {
        
    }
}
