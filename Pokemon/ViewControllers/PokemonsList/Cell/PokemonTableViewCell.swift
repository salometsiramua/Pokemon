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
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(avatar)
        stackView.addArrangedSubview(name)
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView)
        contentView.addSubview(spinner)
        contentView.backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        
        stackView.pin(to: contentView, edgeInsets: .init(top: 0, left: Constants.Spacing.margin.value, bottom: 0, right: Constants.Spacing.margin.value))
        
        name.textColor = Constants.Colors.title.value
        name.textAlignment = .center
        name.font = .systemFont(ofSize: 30)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        spinner.hidesWhenStopped = true
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFit
        avatar.widthAnchor.constraint(equalToConstant: contentView.frame.height * 1.5).isActive = true
    }
}

extension PokemonTableViewCell: PokemonTableViewCellConfigurable {
    func configure(with viewModel: PokemonCellViewModel?) {
        name.text = viewModel?.name.uppercased()
        
        if viewModel == nil {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
        
        avatar.image = UIImage(named: "placeholder")
    }
}
