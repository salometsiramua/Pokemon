//
//  PokemonsDetailsViewController.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

protocol PokemonsDetailsUpdatedListener {
    func reload()
    func showError(error: Error)
    func appendImage(image: UIImage)
}


class PokemonsDetailsViewController: UIViewController {
    
    var viewModel: PokemonsDetailsViewModel?
    
    private var name = UILabel(frame: .zero)
    private var weight = UILabel(frame: .zero)
    
    //private var verticalStackView = UIScrollView(frame: .zero)
    private var imagesContainerScrollView = UIScrollView(frame: .zero)
    private var horizontalImagesStackView = UIStackView(frame: .zero)
    
    private var statsStackView = UIStackView(frame: .zero)
    private var typesStackView = UIStackView(frame: .zero)
    
    private var pageControl = UIPageControl(frame: .zero)
    
    override func loadView() {
        super.loadView()
        
        setupUI()
        
        viewModel?.delegate = self
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel?.pokemon == nil else {
            return
        }
        
        viewModel?.fetchDetails()
    }
    
    private func setupUI() {
        let backgroundView = UIImageView(image: UIImage(named: "green"))
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(backgroundView)
        backgroundView.pin(to: view)
        
        view.addSubview(imagesContainerScrollView)
        
        imagesContainerScrollView.translatesAutoresizingMaskIntoConstraints = false
        imagesContainerScrollView.pinToTop(to: view, edgeInsets: .init(top: Constants.Spacing.margin.value, left: 0, bottom: 0, right: 0))
        
        imagesContainerScrollView.showsVerticalScrollIndicator = false
        imagesContainerScrollView.showsHorizontalScrollIndicator = false
        imagesContainerScrollView.addSubview(horizontalImagesStackView)
        imagesContainerScrollView.delegate = self
        
        horizontalImagesStackView.pin(to: imagesContainerScrollView)
        
        imagesContainerScrollView.heightAnchor.constraint(equalTo: horizontalImagesStackView.heightAnchor).isActive = true
        
        imagesContainerScrollView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imagesContainerScrollView.isPagingEnabled = true
        
        horizontalImagesStackView.axis = .horizontal
        horizontalImagesStackView.distribution = .equalSpacing
        horizontalImagesStackView.alignment = .fill
        horizontalImagesStackView.spacing = 0
        horizontalImagesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = Constants.Colors.title.value
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.tintColor = .gray
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .green
        
        view.addSubview(pageControl)
        
        pageControl.topAnchor.constraint(equalTo: imagesContainerScrollView.bottomAnchor, constant: Constants.Spacing.padding.value).isActive = true
        pageControl.pinToEdges(to: view)
        
        view.addSubview(name)
        
        name.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: Constants.Spacing.padding.value).isActive = true
        name.pinToEdges(to: view)
        name.textAlignment = .center
        name.font = .boldSystemFont(ofSize: 25)
        
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.axis = .vertical
        view.addSubview(statsStackView)
        statsStackView.pinToBottom(to: view, edgeInsets: .init(top: 0, left: Constants.Spacing.margin.value, bottom: Constants.Spacing.margin.value, right: Constants.Spacing.margin.value))
        statsStackView.spacing = Constants.Spacing.padding.value
        statsStackView.alignment = .leading
        
        typesStackView.translatesAutoresizingMaskIntoConstraints = false
        typesStackView.axis = .vertical
        view.addSubview(typesStackView)
        typesStackView.pinToBottom(to: view, edgeInsets: .init(top: 0, left: Constants.Spacing.margin.value, bottom: Constants.Spacing.margin.value, right: Constants.Spacing.margin.value))
        typesStackView.spacing = Constants.Spacing.padding.value
        typesStackView.alignment = .trailing
    }
}

extension PokemonsDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

extension PokemonsDetailsViewController: PokemonsDetailsUpdatedListener {
    
    func appendImage(image: UIImage) {
        let imageView = UIImageView(frame: .zero)
        imageView.widthAnchor.constraint(equalToConstant: imagesContainerScrollView.frame.width).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        horizontalImagesStackView.addArrangedSubview(imageView)
        
        pageControl.numberOfPages = horizontalImagesStackView.arrangedSubviews.count
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.name.text = self.viewModel?.pokemon?.name
            self.fillStatsStackView()
            self.fillTypesStackView()
        }
    }
    
    func fillStatsStackView() {
        
        viewModel?.pokemon?.stats.forEach({ (stat) in
            let view = UIView()
            let title = UILabel()
            let value = UILabel()
            view.addSubview(title)
            view.addSubview(value)
            
            title.pinToTop(to: view)
            value.pinToBottom(to: view)
            title.bottomAnchor.constraint(equalTo: value.topAnchor).isActive = true
            
            view.translatesAutoresizingMaskIntoConstraints = false
            title.translatesAutoresizingMaskIntoConstraints = false
            value.translatesAutoresizingMaskIntoConstraints = false
            
            title.text = "\(stat.stat.name):"
            value.text = "\(stat.effort)/\(stat.baseStat)"
            statsStackView.addArrangedSubview(view)
        })
    }
    
    func fillTypesStackView() {
        
        viewModel?.pokemon?.types.forEach({ (type) in
            let view = UIView()
            let title = UILabel()
            let value = UILabel()
            view.addSubview(title)
            view.addSubview(value)
            
            title.pinToTop(to: view)
            value.pinToBottom(to: view)
            title.bottomAnchor.constraint(equalTo: value.topAnchor).isActive = true
            
            view.translatesAutoresizingMaskIntoConstraints = false
            title.translatesAutoresizingMaskIntoConstraints = false
            value.translatesAutoresizingMaskIntoConstraints = false
            
            title.text = "\(type.type.name):"
            value.text = "\(type.slot)"
            typesStackView.addArrangedSubview(view)
        })
    }
}
