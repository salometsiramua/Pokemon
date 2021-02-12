//
//  PokemonsListViewModel.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import UIKit
import CoreData

protocol PokemonsListViewModel {
    
    var totalCount: Int { get }
    var pokemons: [Int: PokemonCellViewModel] { get }
    var delegate: PokemonsDataSourceUpdatedListener? { get set }
    func fetchPokemons(for indexes: [Int])
    func suspendAllOperations()
    func resumeAllOperations()
    func image(for cell: IndexPath)
    func images(for cells: [IndexPath]?)
}

final class PokemonsListViewModelService: PokemonsListViewModel {
    
    var delegate: PokemonsDataSourceUpdatedListener?
    private let batchSize = 20
    private(set) var totalCount: Int = 0
    private(set) var pokemons: [Int: PokemonCellViewModel] = [:]
    private let pendingOperations = PendingOperations()
    
    private var pokemonsListFetcher: PokemonsListFetcher
    private let dataBaseManager: DataBaseManager
    
    init(pokemonsListFetcher: PokemonsListFetcher = PokemonsListFetcherService(), dataBaseManager: DataBaseManager = CoreDataManager.sharedManager) {
        self.pokemonsListFetcher = pokemonsListFetcher
        self.dataBaseManager = dataBaseManager
    }
    
    func image(for cell: IndexPath) {
        guard let model = pokemons[cell.row], model.image.state == .new else {
            return
        }
        
        startDownload(for: model.image, at: cell)
    }
    
    func images(for cells: [IndexPath]?) {
        
        guard let cells = cells else { return }
        
        let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(cells)
        toBeCancelled.subtract(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        toBeCancelled.forEach { (indexPath) in
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        }
        
        toBeStarted.filter{ pokemons[$0.row]?.image.state == ImageState.new}.forEach { (indexPath) in
            guard let image = pokemons[indexPath.row]?.image else { return }
            startDownload(for: image, at: indexPath)
        }
    }
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func fetchPokemons(for indexes: [Int]) {
        
        guard Reachability.isConnectedToNetwork else {
            delegate?.showAlert(with: NetworkError.noInternetConnection)
            fetchFromCoreData()
            return
        }
        
        let skip = batchStartIndex(for: indexes.last ?? 0)
        
        pokemonsListFetcher.fetch(take: batchSize, skip: skip){ [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let pokemonsList):
                self.totalCount = pokemonsList.count
                let pokemons = pokemonsList.results.compactMap { PokemonCellViewModel(name: $0.name, url: $0.url, image: Image(url: self.imageUrl(for: $0.url)))}
                
                let batchStartIndex = self.batchStartIndex(from: pokemonsList.previous, nextUrl: pokemonsList.next)
                pokemons.enumerated().forEach { (index, model) in
                    let itemIndex = batchStartIndex + index
                    self.pokemons[itemIndex] = model
                }
                
                self.delegate?.reloadTable(rows: self.indexPathsToReload(from: pokemonsList.results))
                self.save(results: pokemons)
            case .failure(let error):
                self.delegate?.showAlert(with: error)
            }
        }
    }
    
    private func batchStartIndex(for index: Int) -> Int {
        return index - (index % batchSize)
    }
    
    private func batchStartIndex(from previousUrl: String?, nextUrl: String?) -> Int {
        
        guard let offset = offsetFromUrl(string: previousUrl) else {
            return (offsetFromUrl(string: nextUrl) ?? batchSize) - batchSize
        }
        
        return offset + batchSize
    }
    
    private func offsetFromUrl(string: String?) -> Int? {
        guard let string = string else { return nil }
        guard let start = string.range(of: "offset=")?.upperBound, let end = string.range(of: "&limit")?.lowerBound else {
            return nil
        }
        return Int(string[start..<end]) ??  0
    }
    
    private func indexPathsToReload(from result: [PokemonsBasicData]) -> [IndexPath] {
        let startIndex = pokemons.count - result.count
        let endIndex = startIndex + result.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func startDownload(for photoRecord: Image, at indexPath: IndexPath) {

        guard pendingOperations.downloadsInProgress[indexPath] == nil, pokemons[indexPath.row]?.image.state == ImageState.new else {
            return
        }
        
        let downloader = ImageDownloader(photoRecord, indexPath: indexPath)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pokemons[indexPath.row]?.image = downloader.image
                guard let model = self.pokemons[indexPath.row] else { return }
                self.saveImage(for: model)
                self.pendingOperations.downloadsInProgress.removeValue(forKey: downloader.indexPath)
                self.delegate?.reloadTable(rows: [downloader.indexPath])
            }
            
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    private func imageUrl(for url: String) -> String? {
        
        guard let index = url.pokemonsIndex, !index.isEmpty, let imageURL = ImagePath.offitialArtworkFrontDefault.absoluteString(for: index) else {
            return nil
        }
        
        return imageURL
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
        
        pokemons = [:]
        list.enumerated().forEach { (index, element) in
            let image = element.image == nil ? nil : UIImage(data: element.image!)
            guard let url = element.url else { return }
            pokemons[index] = PokemonCellViewModel(name: element.name, url: url, image: Image(url: imageUrl(for: url), image: image))
        }
        
        totalCount = pokemons.count
        
        delegate?.reloadTable(rows: [])
    }
}
