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
            .subscribe { person in
                self.personImage.sd_setImage(with: URL(string: person.profileImageUrl), placeholderImage: UIImage(named: "user"))
                self.personNameLabel.text = person.name
            } onError: { error in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: loaderView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(personImage)
        view.addSubview(personNameLabel)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            personImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            personImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            personNameLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 8),
            personNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            personNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        
        return loader
    }()
}
