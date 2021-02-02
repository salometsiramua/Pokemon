//
//  PokemonsListViewController.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 02.02.21.
//

import UIKit

class PokemonsListViewController: UIViewController {

    lazy var viewModel: PokemonsListViewModel = PokemonsListViewModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    override func loadView() {
//        view = UIView(frame: UIScreen.main.bounds)
//        view.backgroundColor = .red
//    }

}
