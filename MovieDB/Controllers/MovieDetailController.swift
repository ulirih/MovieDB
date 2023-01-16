//
//  MovieDetailController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 12.01.2023.
//

import UIKit
import RxSwift

class MovieDetailController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        title = "Details"
        
        setupViews()
        setupConstrains()
        
        let service = Service()
        service.fetchMovieDetail(movieId: movieId!)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] model in
                self?.imagePoster.sd_setImage(with: URL(string: model.backdropUrl), completed: nil)
                self?.nameLabel.text = model.title
                self?.markView.value = model.voteAverage
                self?.descriptionLabel.text = model.overview
            } onFailure: { error in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(imagePoster)
        view.addSubview(nameLabel)
        view.addSubview(markView)
        view.addSubview(descriptionLabel)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            imagePoster.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagePoster.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagePoster.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagePoster.heightAnchor.constraint(equalToConstant: 250),
            
            nameLabel.topAnchor.constraint(equalTo: imagePoster.bottomAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: markView.leadingAnchor, constant: 8),
            
            markView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            markView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private let imagePoster: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .label
        name.numberOfLines = 0
        name.font = UIFont.getNunitoFont(type: .regular, size: 22)
        return name
    }()
    
    private let markView: MarkView = {
        let mark = MarkView()
        mark.translatesAutoresizingMaskIntoConstraints = false
        return mark
    }()
    
    private let descriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = .label.withAlphaComponent(0.7)
        description.numberOfLines = 0
        description.font = UIFont.getNunitoFont(type: .regular, size: 18)
        
        return description
    }()

}
