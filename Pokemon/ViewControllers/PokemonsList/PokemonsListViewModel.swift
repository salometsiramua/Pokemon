//
//  PokemonsListViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import UIKit
import CoreData

struct ImageCache {
    var image: UIImage
    var index: Int
}

protocol PokemonsListViewModel {
    
    var totalCount: Int { get }
    var pokemons: [PokemonCellViewModel] { get }
    var delegate: PokemonsDataSourceUpdatedListener? { get set }
    func fetchPokemons()
    func image(for indexPath: IndexPath, completion: @escaping (Result<ImageCache, Error>) -> Void)
}

final class PokemonsListViewModelService: PokemonsListViewModel {
    
    var delegate: PokemonsDataSourceUpdatedListener?
    
    var totalCount: Int = 0
    private var downloadedCount: Int = 0
    private var next: String?
    private var previous: String?
    private var isFetching: Bool = false
    
    private(set) var pokemons: [PokemonCellViewModel] = []
    
    private let pokemonsListFetcher: PokemonsListFetcher
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let dataBaseManager: DataBaseManager
    
    init(pokemonsListFetcher: PokemonsListFetcher = PokemonsListFetcherService(), dataBaseManager: DataBaseManager = CoreDataManager.sharedManager) {
        self.pokemonsListFetcher = pokemonsListFetcher
        self.dataBaseManager = dataBaseManager
    }
    
    func fetchPokemons() {
        
        guard Reachability.isConnectedToNetwork else {
            delegate?.showAlert(with: NetworkError.noInternetConnection)
            fetchFromCoreData()
            return
        }
        
        guard !isFetching else { return }
        
        isFetching = true
        pokemonsListFetcher.fetch(url: next) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let pokemonsList):
                self.isFetching = false
                self.totalCount = pokemonsList.count
                self.next = pokemonsList.next
                self.previous = pokemonsList.previous
                let pokemons = pokemonsList.results.compactMap { PokemonCellViewModel(name: $0.name, url: $0.url, image: nil)}
                self.pokemons.append(contentsOf: pokemons)
                self.delegate?.reloadTable(rows: self.indexPathsToReload(from: pokemonsList.results))
                self.save(results: pokemons)
            case .failure(let error):
                self.isFetching = false
                self.delegate?.showAlert(with: error)
            }
        }
    }
    
    private func indexPathsToReload(from result: [PokemonsBasicData]) -> [IndexPath] {
        let startIndex = pokemons.count - result.count
        let endIndex = startIndex + result.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func image(for indexPath: IndexPath, completion: @escaping (Result<ImageCache, Error>) -> Void) {
        let itemNumber = NSNumber(value: indexPath.item)
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            completion(.success(ImageCache(image: cachedImage, index: indexPath.row)))
            return
        }
        
        guard indexPath.row < pokemons.count else {
            return
        }
        
        let url = pokemons[indexPath.row].url
        
        guard let imageUrl = imageUrl(for: url) else {
            completion(.failure(NetworkError.urlIsInvalid))
            return
        }
        
        self.loadImage(url: imageUrl) { [weak self] (image) in
            guard let self = self, let image = image else { return }
            
            completion(.success(ImageCache(image: image, index: indexPath.row)))
            self.pokemons[indexPath.row].image = image
            self.cache.setObject(image, forKey: itemNumber)
            self.saveImage(for: self.pokemons[indexPath.row])
        }
    }
    
    private func imageUrl(for url: String) -> String? {
        
        guard let index = url.pokemonsIndex, !index.isEmpty, let imageURL = ImagePath.offitialArtworkFrontDefault.absoluteString(for: index) else {
            return nil
        }
        
        return imageURL
    }
    
    private func loadImage(url: String, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let unwrappedUrl = URL(string: url), let data = try? Data(contentsOf: unwrappedUrl) else { return }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
    }
    
    private func save(results: [PokemonCellViewModel]) {
        dataBaseManager.save(results: results)
    }
    
    private func saveImage(for model: PokemonCellViewModel) {
        dataBaseManager.saveImage(for: model)
    }
    
    private func fetchFromCoreData() {
        guard let list = dataBaseManager.fetchPokemonsList() else {
            return
        }
        
        pokemons = list.compactMap { PokemonCellViewModel(name: $0.name, url: $0.url, image: $0.image == nil ? nil : UIImage(data: $0.image!))
        }
        totalCount = pokemons.count
        
        delegate?.reloadTable(rows: [])
    }
}
