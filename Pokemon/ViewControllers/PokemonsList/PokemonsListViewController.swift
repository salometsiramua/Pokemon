//
//  PokemonsListViewController.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import UIKit

protocol PokemonsDataSourceUpdatedListener {
    func reloadTable(rows: [IndexPath])
    func showAlert(with error: Error)
}

class PokemonsListViewController: UIViewController {
    
    lazy var viewModel: PokemonsListViewModel = PokemonsListViewModelService()
    
    private let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let titleView = UIView()
        titleView.backgroundColor = .clear
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleView.addSubview(titleImageView)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.pinToCenter(to: titleView)
        titleImageView.heightAnchor.constraint(equalToConstant: navigationController?.navigationBar.frame.height ?? 44).isActive = true
        titleImageView.widthAnchor.constraint(equalTo: titleImageView.heightAnchor, multiplier: 1024/377).isActive = true
        
        navigationItem.titleView = titleView
        setupBackgroundView()
        setupTableView()
    }
    
    private func setupBackgroundView() {
        let backgroundImageView = UIImageView(image: UIImage(named: "green"))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.pin(to: view)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let topMargin = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.size.height ?? 44)
        tableView.pin(to: view, edgeInsets: .init(top: topMargin, left: 0, bottom: 0, right: 0))
        
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.identifier)
        
        tableView.backgroundColor = .clear
        viewModel.delegate = self
        viewModel.fetchPokemons()
    }
    
    internal func showAlert(with error: Error) {
        
    }
}

extension PokemonsListViewController: UITableViewDelegate {
    
}

extension PokemonsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.identifier, for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        cell.backgroundView = nil
        cell.selectionStyle = .none
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
        } else {
            cell.configure(with: viewModel.pokemons[indexPath.row])
        }
        
        cell.tag = indexPath.row
        
        viewModel.image(for: indexPath) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageCache):
                    guard cell.tag == imageCache.index else {
                        return
                    }
                    cell.avatar.image = imageCache.image
                case .failure(let error):
                    self?.showAlert(with: error)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonDetailsViewController = PokemonsDetailsViewController()
        pokemonDetailsViewController.viewModel = PokemonsDetailsViewModelService(url: viewModel.pokemons[indexPath.row].url)
        navigationController?.pushViewController(pokemonDetailsViewController, animated: true)
    }
}

extension PokemonsListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPokemons()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.pokemons.count
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension PokemonsListViewController: PokemonsDataSourceUpdatedListener {
    
    func reloadTable(rows: [IndexPath]) {
        DispatchQueue.main.async {
            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: rows)
            guard !indexPathsToReload.isEmpty else {
                self.tableView.reloadData()
                return
            }
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            
        }
    }
}
