//
//  PersonViewController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 19.01.2023.
//

import UIKit
import RxSwift

class PersonViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel: PersonViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        title = "Person"
        
        setupViews()
        setupConstrains()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchPerson()
    }
    
    private func setupBindings() {
        viewModel.person
            .subscribe { [weak self] person in
                self?.personImage.sd_setImage(with: URL(string: person.profileImageUrl), placeholderImage: UIImage(named: "user"))
                self?.personNameLabel.text = person.name
                self?.descriptionLabel.text = person.biography
            } onError: { error in
                self.view.addSubview(ErrorView(center: self.view.center))
            }.disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: loaderView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        contentView.addSubview(personImage)
        contentView.addSubview(personNameLabel)
        contentView.addSubview(loaderView)
        contentView.addSubview(descriptionLabel)
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            personImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            personImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            personNameLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 8),
            personNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            personNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private let personImage: UIImageView = {
        let imageSize = CGFloat(160)
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        image.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        image.layer.cornerRadius = imageSize / 2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private let personNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getNunitoFont(type: .bold, size: 18)
        label.textColor = .label
        label.textAlignment = .center
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getNunitoFont(type: .regular)
        label.textColor = .label.withAlphaComponent(0.8)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        
        return loader
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
}
