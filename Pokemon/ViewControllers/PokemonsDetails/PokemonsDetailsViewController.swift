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

enum DetailsScreenScrollViews: Int {
    case main
    case images
}

class PokemonsDetailsViewController: UIViewController {
    
    var viewModel: PokemonsDetailsViewModel?
    
    private var name = UILabel(frame: .zero)
    private var weight = UILabel(frame: .zero)
    private var types = UILabel(frame: .zero)
    
    private var mainScrollView = UIScrollView(frame: .zero)
    private var verticalStackView = UIStackView(frame: .zero)
    private var imagesContainerScrollView = UIScrollView(frame: .zero)
    private var horizontalImagesStackView = UIStackView(frame: .zero)
    
    private var statsStackView = UIStackView(frame: .zero)
    
    private var pageControl = UIPageControl(frame: .zero)
    
    override func loadView() {
        super.loadView()
        
        setupMainView()
        setupImagesStack()
        setupComponents()
        
        viewModel?.delegate = self
        navigationController?.navigationBar.tintColor = .black
        
        startIndicatingActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel?.pokemon == nil else {
            return
        }
        
        viewModel?.fetchDetails()
    }
    
    private func setupMainView() {
        let backgroundView = UIImageView(image: UIImage(named: "green"))
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(backgroundView)
        backgroundView.pin(to: view)
        
        view.addSubview(mainScrollView)
        mainScrollView.pin(to: view)
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(verticalStackView)
        mainScrollView.tag = DetailsScreenScrollViews.main.rawValue
        
        verticalStackView.pin(to: mainScrollView, edgeInsets: .init(top: 0, left: 0, bottom: Constants.Spacing.margin.value, right: 0))
        verticalStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = Constants.Spacing.margin.value
    }
    
    private func setupImagesStack() {
        verticalStackView.addArrangedSubview(imagesContainerScrollView)
        
        imagesContainerScrollView.translatesAutoresizingMaskIntoConstraints = false
        imagesContainerScrollView.tag = DetailsScreenScrollViews.images.rawValue
        imagesContainerScrollView.showsVerticalScrollIndicator = false
        imagesContainerScrollView.showsHorizontalScrollIndicator = false
        imagesContainerScrollView.addSubview(horizontalImagesStackView)
        imagesContainerScrollView.delegate = self
        imagesContainerScrollView.heightAnchor.constraint(equalTo: horizontalImagesStackView.heightAnchor).isActive = true
        imagesContainerScrollView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        imagesContainerScrollView.isPagingEnabled = true
        
        horizontalImagesStackView.pin(to: imagesContainerScrollView)
        horizontalImagesStackView.axis = .horizontal
        horizontalImagesStackView.distribution = .equalSpacing
        horizontalImagesStackView.alignment = .fill
        horizontalImagesStackView.spacing = 0
        horizontalImagesStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupComponents() {
    
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.setStyle(.title)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.tintColor = .gray
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .green
        
        verticalStackView.addArrangedSubview(pageControl)
        verticalStackView.addArrangedSubview(name)
        
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.axis = .vertical
        statsStackView.spacing = Constants.Spacing.padding.value
        
        verticalStackView.addArrangedSubview(types)
        verticalStackView.addArrangedSubview(statsStackView)
        
        statsStackView.spacing = Constants.Spacing.margin.value
        statsStackView.alignment = .center
        
        types.translatesAutoresizingMaskIntoConstraints = false
        types.textAlignment = .center
        types.setStyle(.header)
    }
}

extension PokemonsDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.tag == DetailsScreenScrollViews.images.rawValue else {
            return
        }
        
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView.tag == DetailsScreenScrollViews.images.rawValue else {
            return
        }
        
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
            self.stopIndicatingActivity()
            self.name.text = self.viewModel?.pokemon?.name.capitalized
            self.fillStatsStackView(with: self.viewModel)
            self.fillTypesStackView(with: self.viewModel)
        }
    }
    
    func fillStatsStackView(with viewModel: PokemonsDetailsViewModel?) {
        viewModel?.pokemon?.stats.forEach({ (stat) in
            let stackView = UIStackView()
            stackView.axis = .vertical
            
            let title = UILabel()
            let progressBar = HorizontalProgressBar(frame: .zero)
            
            stackView.addArrangedSubview(title)
            stackView.addArrangedSubview(progressBar)
            stackView.spacing = Constants.Spacing.padding.value
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            title.translatesAutoresizingMaskIntoConstraints = false
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
            progressBar.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
            progressBar.color = .green
            progressBar.backgroundColor = .white
            progressBar.progress = CGFloat(stat.effort)/CGFloat(stat.baseStat)
            
            title.textAlignment = .left
            title.text = "\(stat.stat.name.capitalized): \(stat.effort)/\(stat.baseStat)"
            title.setStyle(.text)
            statsStackView.addArrangedSubview(stackView)
        })
    }
    
    func fillTypesStackView(with viewModel: PokemonsDetailsViewModel?) {
        var text = ""
        viewModel?.pokemon?.types.forEach({ (type) in
            if !text.isEmpty {
                text += " / "
            }
            text += type.type.name
        })
        types.text = text
    }
}
