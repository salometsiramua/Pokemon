//
//  PokemonTableViewCell.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

protocol PokemonTableViewCellConfigurable {
    func configure(with viewmodel: PokemonCellViewModel?)
}

class PokemonTableViewCell: UITableViewCell {
    
    private var spinner = UIActivityIndicatorView(style: .gray)
    private var name = UILabel()
    private var avatar = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(name)
        //        contentView.addSubview(avatar)
        contentView.addSubview(spinner)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.margin.value).isActive = true
        name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        name.textColor = Constants.Colors.title.value
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        spinner.hidesWhenStopped = true
    }
}

extension PokemonTableViewCell: PokemonTableViewCellConfigurable {
    func configure(with viewModel: PokemonCellViewModel?) {
        name.text = viewModel?.name
        
        if viewModel == nil {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
}
