//
//  PokemonsListViewController.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import UIKit

protocol PokemonsDataSourceUpdatedListener {
    func reloadTable(rows: [IndexPath])
    func showError(error: Error)
}

class PokemonsListViewController: UIViewController {

    lazy var viewModel: PokemonsListViewModel = PokemonsListViewModelService()
    
    private let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Constants.Colors.background.value
        navigationController?.title = "Pokemons"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.identifier)
        
        viewModel.delegate = self
        viewModel.fetchPokemons()
        
//        { [weak self] (response) in
//            switch response {
//            case .success:
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self?.showAlert(with: error)
//                }
//            }
//        }
    }
    
    private func showAlert(with error: Error) {
        
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
        if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
        } else {
            cell.configure(with: viewModel.pokemons[indexPath.row])
        }
        
        return cell
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
    func showError(error: Error) {
        showAlert(with: error)
    }
    
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
