//
//  TrendMovieViewCell.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 29.12.2022.
//

import Foundation
import UIKit
import SDWebImage

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
        blurView.contentView.addSubview(dateLabel)
        
        contentView.addSubview(blurView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 140),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 16),
            image.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: image.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    func configure(model: TrendingModel) {
        nameLabel.text = model.nameDisplay
        dateLabel.text = model.dateDisplay
        image.sd_setImage(with: URL(string: model.posterUrl), completed: nil)
    }
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .label
        name.numberOfLines = 2
        
        return name
    }()
    
    private let dateLabel: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        
        return date
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
