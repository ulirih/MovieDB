//
//  ViewController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 21.12.2022.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel = MainViewModel(service: Service())

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
        view.addSubview(loader)
    }
    
    private func setupBind() {
        viewModel.nowPlaying
            .subscribe(onNext: { movies in
                print(movies.count)
            })
            .disposed(by: disposeBag)
        
        viewModel.trendings
            .subscribe(onNext: { movies in
                print(movies.count)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { isLoading in
                _ = isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        
        return loader
    }()
}

