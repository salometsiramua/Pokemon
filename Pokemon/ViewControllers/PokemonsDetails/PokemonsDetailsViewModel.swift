//
//  PokemonsDetailsViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

protocol PokemonsDetailsViewModel {
    var url: String? { get }
    var pokemon: Pokemon? { get }
    var delegate: PokemonsDetailsUpdatedListener? { get set }
    func fetchDetails()
}

final class PokemonsDetailsViewModelService: PokemonsDetailsViewModel {
    
    var delegate: PokemonsDetailsUpdatedListener?
    var url: String?

    private let pokemonsDetailsFetcher: PokemonsDetailsFetcher
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    var pokemon: Pokemon?
    
    init(pokemonsDetailsFetcher: PokemonsDetailsFetcher = PokemonsDetailsFetcherService(), url: String?) {
        self.pokemonsDetailsFetcher = pokemonsDetailsFetcher
        self.url = url
    }

    func fetchDetails() {
        guard let url = url else { return }
        
        pokemonsDetailsFetcher.fetch(url: url) { [weak self] (result) in
            switch result {
            case .success(let pokemon):
                self?.pokemon = pokemon
                self?.loadImages(from: pokemon.allImages)
                self?.delegate?.reload()
            case .failure(let error):
                self?.delegate?.showAlert(with: error)
            }
        }
    }
    
    private func loadImages(from list: [String]) {
        list.forEach { (url) in
            loadImage(url: url) { [weak self] (image) in
                guard let image = image else {
                    return
                }
                self?.delegate?.appendImage(image: image)
            }
        }
    }
    
    private func loadImage(url: String, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let url = URL(string: url), let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
