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
    private var stackView = UIStackView()
    private var imagesStackView = UIStackView()
    private var name = UILabel()
    public var avatar = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(name)
        
        imagesStackView.axis = .horizontal
        imagesStackView.addArrangedSubview(avatar)
        stackView.addArrangedSubview(imagesStackView)
        contentView.addSubview(stackView)
        
        contentView.addSubview(spinner)
        
        stackView.pin(to: contentView, edgeInsets: .init(top: Constants.Spacing.padding.value, left: Constants.Spacing.margin.value, bottom: Constants.Spacing.padding.value, right: Constants.Spacing.margin.value))
        
        name.textColor = Constants.Colors.title.value
        name.textAlignment = .center
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        spinner.hidesWhenStopped = true
        
        avatar.contentMode = .scaleAspectFit
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
        
        avatar.image = UIImage(named: "placeholder")
    }
}
