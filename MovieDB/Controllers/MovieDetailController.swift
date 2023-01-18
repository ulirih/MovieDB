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
    private var casts: [CastModel] = []
    
    var viewModel: MovieDetailViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        title = "Details"
        
        setupViews()
        setupConstrains()
        setupBindings()
        
        viewModel.fetchDetail()
        viewModel.fetchCasts()
    }
    
    private func setupBindings() {
        viewModel.detail
            .subscribe( onNext: { [weak self] model in
                guard let self = self else { return }
                self.imagePoster.sd_setImage(with: URL(string: model.backdropUrl), completed: nil)
                self.nameLabel.text = model.title
                self.markView.value = model.voteAverage
                self.descriptionLabel.text = model.overview
                self.genreLabel.text = "Genre: \(model.categoriesString)"
            }, onError: { [weak self] error in
                self?.errorView.alpha = 1
            }).disposed(by: disposeBag)
        
        viewModel.cast
            .subscribe(onNext: { casts in
                self.casts = casts
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)


        viewModel.isLoading
            .bind(to: loaderView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(imagePoster)
        view.addSubview(nameLabel)
        view.addSubview(markView)
        view.addSubview(descriptionLabel)
        view.addSubview(genreLabel)
        view.addSubview(loaderView)
        view.addSubview(errorView)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
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
            
            genreLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 22),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 22),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
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
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.getNunitoFont(type: .regular, size: 17)
        
        return label
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.style = .large
        
        return loader
    }()
    
    private let errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 100, height: 150)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(CastViewCell.self, forCellWithReuseIdentifier: CastViewCell.reusableId)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()

}

// MARK: Collection DS
extension MovieDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastViewCell.reusableId, for: indexPath) as! CastViewCell
        cell.configure(model: casts[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(casts.count)
        return casts.count
    }
}
