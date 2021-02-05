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
    func setLoading(hidden: Bool)
}

final class PokemonsListViewController: UIViewController {
    
    lazy var viewModel: PokemonsListViewModel = PokemonsListViewModelService()
    
    private let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.view.backgroundColor = Constants.Colors.clear.value
        navigationController?.navigationBar.shadowImage = UIImage()
        
        setupTitleView()
        startIndicatingActivity()
        setupBackgroundView()
        setupTableView()
        
        view.bringSubviewToFront(indicator)
    }
    
    private func setupTitleView() {
        let titleView = UIView()
        titleView.backgroundColor = Constants.Colors.clear.value
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleView.addSubview(titleImageView)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.pin(to: titleView)
        titleImageView.heightAnchor.constraint(equalToConstant: navigationController?.navigationBar.frame.height ?? 44).isActive = true
        titleImageView.widthAnchor.constraint(equalTo: titleImageView.heightAnchor, multiplier: 1024/377).isActive = true
        
        navigationItem.titleView = titleView
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
        
        tableView.backgroundColor = Constants.Colors.clear.value
        viewModel.delegate = self
        viewModel.fetchPokemons()
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
        
        cell.backgroundColor = Constants.Colors.clear.value
        cell.backgroundView = nil
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        
        guard !isLoadingCell(for: indexPath) else {
            
            cell.configure(with: nil)
            return cell
        }
            
        cell.configure(with: viewModel.pokemons[indexPath.row])
            
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
        let pokemonDetailsViewController = PokemonsDetailsViewController(viewModel: PokemonsDetailsViewModelService(url: viewModel.pokemons[indexPath.row].url))
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
    
    func reloadTable(rows: [IndexPath] = []) {
        stopIndicatingActivity()
        DispatchQueue.main.async {
            guard !rows.isEmpty else {
                self.tableView.reloadData()
                return
            }
            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: rows)
            guard !indexPathsToReload.isEmpty else {
                self.tableView.reloadData()
                return
            }
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            
        }
    }
    
    func setLoading(hidden: Bool) {
        
    }
}
