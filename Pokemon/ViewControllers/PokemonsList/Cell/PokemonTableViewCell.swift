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

final class PokemonTableViewCell: UITableViewCell {
    
    private let spinner = UIActivityIndicatorView(style: .gray)
    private let stackView = UIStackView()
    private let name = UILabel()
    public let avatar = UIImageView()
    
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
        stackView.backgroundColor = Constants.Colors.clear.value
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.Spacing.margin.value
        
        contentView.addSubview(stackView)
        contentView.addSubview(spinner)
        contentView.backgroundColor = Constants.Colors.clear.value
        backgroundView?.backgroundColor = Constants.Colors.clear.value
        
        stackView.pin(to: contentView, directions: [.leading, .top, .bottom], edgeInsets: .init(top: 0, left: Constants.Spacing.margin.value, bottom: 0, right: Constants.Spacing.margin.value))
        
        name.textAlignment = .center
        name.setStyle(.header)
        
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
        
        avatar.image = viewModel?.image.image ?? UIImage(named: "placeholder")
    }
}
