//
//  TrendMovieViewCell.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 29.12.2022.
//

import Foundation
import UIKit

class TrendMovieViewCell: UICollectionViewCell {
    static let reusableId = "TrendMovieViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        blurView.layer.cornerRadius = 10
        blurView.clipsToBounds = true
        blurView.contentView.addSubview(nameLabel)
        blurView.contentView.addSubview(image)
        
        contentView.addSubview(blurView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 60),
            image.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 16),
            image.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: image.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
        ])
    }
    
    func configure(model: TrendingModel) {
        nameLabel.text = model.title ?? model.name
        if model.title?.isEmpty ?? true {
            print(model.id)
        }
        image.image = UIImage(contentsOfFile: model.posterPath)
    }
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .label
        
        return name
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .lightGray
        
        return image
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
