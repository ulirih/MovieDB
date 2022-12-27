//
//  ViewController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 21.12.2022.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel = MainViewModel(service: Service())
    
    private var trends: [TrendingModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MovieDB"
        view.backgroundColor = .systemBackground
        
        setupView()
        setupBind()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    private func setupView() {
        view.addSubview(loaderView)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupBind() {
        viewModel.nowPlaying
            .subscribe(onNext: { movies in
                print(movies.count)
            })
            .disposed(by: disposeBag)
        
        viewModel.trendings
            .subscribe(onNext: { [weak self] movies in
                self?.trends = movies
                self?.collectionView.reloadData()
                print(movies.count)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: loaderView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        
        return loader
    }()
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TrendingCellId")
        
        return collection
    }()
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCellId", for: indexPath)
        cell.backgroundColor = .green
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

